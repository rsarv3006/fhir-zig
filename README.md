# fhir-zig

### Purpose: Building fhir definitions and a fhir validator in zig.

## NOTE: This project is maintained on [codeberg](https://codeberg.org/rsarv3006/fhir-zig)

Mirrored to Github for visibility.

## Project Status: WIP

[Kanban board on Codeberg](https://codeberg.org/rsarv3006/fhir-zig/projects/60386)

Currently a major work in progress. Good news though! The R4 and R4 base type files are generated and seem to be (mostly) correct from what I can tell. Further testing needed for sure.

## RoadMap

### Step 1: Codegen

Step One is to build valid, robust and most importantly working Codegen of FHIR types in Zig. This addresses a large gap in the Zig ecosystem and it also a great learning Experience. Ensure compatibility with standard FHIR versions and the common IG versions as well.

### Step 2: Validator

This is where the rubber meets the metaphorical road. To address the common complaints with the de facto standard (java) fhir validator. This validator will be written in zig to take advantage of the lower level access to make it faster and less memory intensive. ....At least that's the plan. Step 2 is to just get a working validator
STREAMING VALIDATOR - absolute must, built from the ground up to stream

### Step 3: Validator Polish

Make sure the validator is on par w/ the standard benchmark and minimize memory usage.

## Output

built schema files are in the output folder

## AI Policy

AI will NOT write any of the code for this project directly. Used for archictecture and spec discussion. Validation of all AI output is required. Do not PR AI Slop.

## Notes

Curl command for the r4 definitions

```sh
curl -o r4schemajson.zip https://hl7.org/fhir/R4/definitions.json.zip
curl -o r5schemajson.zip https://hl7.org/fhir/R5/definitions.json.zip
```
