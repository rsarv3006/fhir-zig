// TODO:: set description field on needed fields
// TODO:: make sure pattern is set where it's available

const std = @import("std");

pub const FhirType_Primitive = struct {
    pattern: ?[]const u8,
    name: []const u8,
    type: []const u8,
};

pub const FhirType_Structure = struct {
    name: []const u8,
    description: ?[]const u8,
    fields: std.ArrayList(FhirField),
    is_resource: bool,
};

pub const FhirType_Enumeration = struct {
    name: []const u8,
    description: ?[]const u8,
    variants: []const []const u8,
};

pub const FhirType_OneOf = struct {
    name: []const u8,
    refs: []const []const u8,
};

pub const FhirField = struct {
    name: []const u8,
    description: ?[]const u8,
    type_ref: FieldType,
    is_optional: bool,
    is_slice: bool,
    is_boxed: bool = false,
    min: u32 = 0,
    max: ?u32 = null, // null = unbounded
};

pub const FieldType = union(enum) {
    ref: []const u8,
    primitive: []const u8,
    inline_enum: []const []const u8,
    choice: []const ChoiceOption,
};

pub const ChoiceOption = struct { suffix: []const u8, typeRef: FieldType };

pub const FhirType = union(enum) {
    primitive: FhirType_Primitive,
    structure: FhirType_Structure,
    enumeration: FhirType_Enumeration,
    oneOf: FhirType_OneOf,
};

pub const FhirIntermediateRepresentationError = error{
    MissingDefinitions,
    InvalidFormat,
    OutOfMemory,
    MissingEntryJsonValue,
    BundleEntryNotAnArray,
    NoResourceObjOnEntry,
    EntryResourceNotAnObject,
};
