# fhir-zig

Building fhir definitions in zig from the schema.json file.

This is very much a work in progress with TODO's and footguns as far as the eye can see (and just past it for fun).

## Project Status: WIP

Currently a major work in progress. Good news though! The R4 and R4 base type files are generated and seem to be (mostly) correct from what I can tell. Further testing needed for sure.

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
- this thing is about as robust as tissue paper in a hurricane, intermediate representation needs better json validation and error handling
