.PHONY: run test clean fmt

# Run the main application
run:
	zig build run
	zig fmt src/r5/generated/fhir.zig && zig fmt src/r4/generated/fhir.zig

# Run all tests with full summary output
test:
	zig build test --summary all

# Clean build artifacts
clean:
	rm -rf zig-out zig-cache   

fmt:
	zig fmt src/r5/generated/fhir.zig && zig fmt src/r4/generated/fhir.zig
