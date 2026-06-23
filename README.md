# fhir-zig

Building fhir definitions in zig from the schema.json file.

TODO: Go find the link I used for the R4 schema and automate it.

This is very much a work in progress with TODO's and footguns as far as the eye can see (and just past it for fun).

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

-
