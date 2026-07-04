# fhir-zig

Building fhir definitions in zig from the schema.json file.

This is very much a work in progress with TODO's and footguns as far as the eye can see (and just past it for fun).

## Project Status: WIP

Currently a major work in progress. Good news though! The R4 and R4 base type files are generated and seem to be (mostly) correct from what I can tell. Further testing needed for sure.

## Output

built schema files are in the output folder (just a heads up zls sometimes chokes on the huuuge files there)

## AI Policy

AI will NOT right any of the code for this project directly.

## Notes

Curl command for the r4 definitions

```sh
curl -o r4schemajson.zip https://hl7.org/fhir/R4/definitions.json.zip
curl -o r5schemajson.zip https://hl7.org/fhir/R5/definitions.json.zip
```

## TODO

-4. The dotted-field branch never checks isFieldBackboneElement on the child itself — so multi-level nesting isn't actually handled yet.
This is the one that'll bite you on ElementDefinition.slicing.discriminator specifically, which you'll hit constantly since you're parsing ElementDefinition instances to drive the whole pipeline. Walk through what happens today:

You see "slicing" (no dot) → isFieldBackboneElement fires → you create ElementDefinition_Slicing, push "slicing" into fhirTypesLookup. Good.
You see "slicing.discriminator" (has a dot) → it goes into the dotted branch, matches "slicing", strips to "discriminator", and appends it directly onto ElementDefinition_Slicing.fields — but field.type_ref is untouched. If discriminator is itself a BackboneElement (it is, in real ElementDefinition), you've just baked a .ref = "BackboneElement" into the emitted field forever, with no ElementDefinition_Slicing_Discriminator type ever created, and no lookup entry for "discriminator" for any its children (slicing.discriminator.something, if it existed) to find.

The dotted branch needs to re-run the same isFieldBackboneElement check on the stripped field before deciding to just append it — if the stripped field is itself a backbone, you need to synthesize a new type for it (same as the top-level case), rewrite its type_ref, and — critically — push a new lookup entry using the full original dotted prefix ("slicing.discriminator", not just "discriminator") so that any further nested children route correctly. This means your current one-shot if/else if/else structure needs to become recursive or at least loop until no more dots need stripping, rather than a single pass per field.
