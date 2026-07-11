# fhir-zig

Building fhir definitions and a fhir validator in zig.

This is very much a work in progress with TODO's and footguns as far as the eye can see (and just past it for fun).

## Project Status: WIP

Currently a major work in progress. Good news though! The R4 and R4 base type files are generated and seem to be (mostly) correct from what I can tell. Further testing needed for sure.

## RoadMap

Status: Step 1

### Step 1: Codegen

Step One is to build valid, robust and most importantly working Codegen of FHIR types in Zig. This addresses a large gap in the Zig ecosystem and it also a great learning Experience. Ensure compatibility with standard FHIR versions and the common IG versions as well.

### Step 2: Validator

This is where the rubber meets the metaphorical road. To address the common complaints with the de facto standard (java) fhir validator. This validator will be written in zig to take advantage of the lower level access to make it faster and less memory intensive. ....At least that's the plan. Step 2 is to just get a working validator

### Step 3: Validator Polish

Make sure the validator is on par w/ the standard benchmark and minimize memory usage.

## Output

built schema files are in the output folder (just a heads up zls sometimes chokes on the huuuge files there)

## AI Policy

AI will NOT write any of the code for this project directly.

## Notes

Curl command for the r4 definitions

```sh
curl -o r4schemajson.zip https://hl7.org/fhir/R4/definitions.json.zip
curl -o r5schemajson.zip https://hl7.org/fhir/R5/definitions.json.zip
```

## TODO

- primitive sibling element fields are missing for everything
- codegen is about as robust as tissue paper in a hurricane, intermediate representation needs better json validation and error handling
