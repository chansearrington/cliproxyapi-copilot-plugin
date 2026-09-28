package main

import "testing"

func TestPluginRegistrationDeclaresSchemaOne(t *testing.T) {
	t.Parallel()

	if got := pluginRegistration().SchemaVersion; got != 1 {
		t.Fatalf("SchemaVersion = %d, want 1 so older hosts can load the plugin", got)
	}
}
