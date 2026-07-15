# fhir-zig: JSON Codec Architecture Notes

Status: design notes, no codec code written yet. Captures the shape of the
decode/encode problem before implementation starts.

## Background: why this doc exists

The IR (`ir.zig`) and emitter (`emitter.zig`) generate Zig types from FHIR
StructureDefinition bundles. No serialization/deserialization code exists
yet. Before writing any, this doc identifies the distinct _shapes_ of
decode/encode behavior the generated types require, so the codec can be
designed around a small number of generic cases instead of one hand-written
implementation per generated type.

## Prerequisite: the primitive-wrapper design decision

Every FHIR primitive type (`boolean`, `code`, `uri`, `dateTime`, `decimal`,
...) is generated as its own Zig struct with three fields: `id`,
`extension`, `value`. Ordinary fields that hold a primitive type (e.g.
`Patient.active: ?boolean`, `Patient.language: ?code`) resolve to `.ref`
pointing at that wrapper struct, not to a bare Zig scalar.

This was a deliberate choice against the "flattened" style used by some
other FHIR codegens (e.g. widely-used TS definitions), which represent a
primitive as a bare scalar field (`gender?: string`) plus a separate
sibling field for id/extension (`_gender?: Element`). The flattened style
exists because JSON's wire format has nowhere else to put id/extension
except a sibling key — it's a wire-format constraint, not a data-modeling
requirement. Since Zig structs aren't under that constraint, wrapping
id/extension/value together in one struct avoids the two-separate-fields
duplication entirely, at the emitted-type level.

**Consequence confirmed by grep** (see "Primitive shadow fields" below):
under this design, no ordinary resource or complex-type field ever needs an
external `_fieldName` sibling struct field. `.primitive` (the bare,
unwrapped `FieldType` variant) only ever appears as the innermost `value`
field of a primitive wrapper struct itself — never on an ordinary field.
The shadow problem is fully absorbed by the wrapper design at the IR/struct
level. It only resurfaces at the JSON boundary, which is what this doc is
about.

## Scope: decode-first, encode secondary

The target use case is a validator consuming JSON and/or NDJSON files —
not a FHIR server, not an application constructing resources by hand. That
changes priorities:

- **Decode is the primary path.** Every field-shape category below needs
  correct, careful decode logic, since that's what runs on every field of
  every instance being validated.
- **Encode is secondary/best-effort.** Nobody is expected to hand-author
  `Patient` literals and encode them out in normal usage (see `main.zig`'s
  `.of()`-style construction — that's a convenience for tests/examples,
  not the primary interface). Some round-trip capability is still useful
  (normalizing output, diffing), but it doesn't need the same level of
  polish as decode.
- **NDJSON requires streaming decode**, not the whole-file
  `std.json.parseFromSlice` approach `testRepFromBundle` currently uses
  for StructureDefinition bundles. Bulk FHIR data ships as
  one-resource-per-line files that can be arbitrarily large; decode needs
  to work per-line against a reader, discarding each resource after
  validation, rather than materializing everything into memory at once.
  This is the same shape of problem as the oldest open TODO in
  `intermediate_representation.zig` (`this crap needs to stream at some
point, file in, ir streamed out`), one level further down the pipeline —
  applied to resource instances rather than StructureDefinition bundles.
  Single-file JSON validation can stay simpler (whole-file parse is fine
  for one resource); NDJSON needs the streaming entry point.

## Field-shape taxonomy for the codec

Six real axes of variation. Each generated field falls into exactly one.

### 1. Primitive wrapper field, single-valued

`.ref` pointing at a primitive wrapper (`code`, `uri`, `dateTime`,
`boolean`, ...), `is_slice = false`.

Wire: up to two keys — `fieldName` (the value) and `_fieldName` (`{id,
extension}`). Either may be absent independently; per spec, id/extension
may be present with no value (e.g. `data-absent-reason` extension pattern),
meaning only the underscore key is emitted with no plain key at all.
Decode/encode must handle: value only, shadow only, both, neither.

### 2. Primitive wrapper field, repeating

Same as (1) but `is_slice = true`.

Wire: **two parallel arrays**, `fieldName: [...]` and `_fieldName: [...]`,
index-aligned. JSON `null` padding fills either array wherever the other
has an entry it doesn't. Decode must zip the two arrays into one array of
wrapper structs; encode must split back into two arrays, including
re-inserting `null` padding at the correct indices.

Precise rule for encode, confirmed against spec: if the two arrays would
end up different lengths, the shorter one is padded with trailing `null`s
to match (don't emit mismatched-length arrays). If the `_fieldName` array
would end up **all** `null` (no element in the repeating field has any
id/extension), omit the `_fieldName` key entirely rather than emitting an
array of nothing but nulls.

### 3. Complex (non-primitive) `.ref` field — single or repeating

One JSON key, nested object or array of objects. No shadow concept
applies. Decode/encode recurse into the target struct's own codec,
whatever it is — general-purpose complex type (`Meta`, `HumanName`), a
backbone-split struct (`Patient_Contact`), doesn't matter, it's the same
recursive case either way.

### 4. Choice-type field (`.choice`)

Discriminator lives in the **key name**: candidate keys are
`fieldName + Capitalize(option.suffix)` for each `ChoiceOption`. Decode
probes each candidate key against the incoming object; whichever is
present determines the active union variant. If that variant's `typeRef`
is itself a primitive wrapper, it also carries its own underscore-shadow
pair under the suffixed name (e.g. `valueBoolean` / `_valueBoolean`). So
choice decode reduces to "resolve which suffix is active, then apply case
1 or case 3 under that suffixed key name."

### 5. Abstract `Resource` polymorphism (`.oneOf`)

Discriminator lives in a **value inside the object**, not the key name:
the `resourceType` property. Decode must peek `resourceType` first, then
dispatch to whichever concrete resource struct's decoder matches. This is
a different mechanism from (4) even though both are "pick one of several
shapes" — don't conflate them. Encode is trivial: whatever concrete
resource is active already carries its own `resourceType` default: just
encode the active variant.

### Not separate codec concerns

- **`is_boxed`**: pure indirection (pointer vs inline) for the
  hardcoded Reference/Identifier embedding cycle. No behavioral difference
  for the codec — decode/encode go through a pointer instead of an inline
  value, that's it.
- **`is_optional` / `min` / `max`**: absence is already handled naturally
  by decode (missing key → `null`). Cardinality _enforcement_ (required
  field missing, `max: 1` field somehow repeated, `max: 0` field
  populated) is validator territory, not codec territory — even though
  decode is where the data would be in hand if an early check were ever
  wanted.

## Design question to resolve before implementation

Hand-written decode/encode per generated type, or one generic pair driven
by comptime reflection (`@typeInfo`, `std.meta.fields`) branching on the
field-shape categories above?

Given the primitive-wrapper shape (`{id, extension, value}`) is identical
across every generated primitive type, and the resource bundle generates
several hundred types, hand-writing per-type codecs means the same
id/extension/value merging logic gets reimplemented that many times — the
same "one rule, multiple independent implementations" failure mode
encountered earlier in this project (struct-naming conventions,
primitive-shadow reasoning). A generic function over "any struct shaped
like `{id, extension, value}}`" plus "any struct with a `.choice`-shaped
field" is a good fit for Zig's comptime model specifically, and isn't as
readily available in the ecosystems (TS, Java) that tend to default to the
flattened representation instead.

## Suggested starting point

`Extension` is the smallest real type that exercises axes 1 (primitive-ish
`url`), 3 (nesting), and 4 (`value[x]` choice) simultaneously, and can
itself nest (child extensions). It's a good forcing function for testing
whether a generic codec design holds up, without needing a full `Patient`
round-trip to find out.

## Open items not yet resolved

- Whether any type besides `Resource` needs `.oneOf` treatment (i.e.
  whether any field resolves directly against the abstract `DomainResource`
  type rather than always bottoming out at a concrete resource).
- `System type with no extension` fallback currently defaults silently to
  `.ref = <raw URI>` when the `structuredefinition-fhir-type` extension is
  absent on a System-typed element. Should probably be a hard error/log
  rather than a silent fallthrough.
