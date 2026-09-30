package main

import "testing"

func TestPluginRegistrationDeclaresSchemaOne(t *testing.T) {
	t.Parallel()

	if got := pluginRegistration().SchemaVersion; got != 1 {
		t.Fatalf("SchemaVersion = %d, want 1 so older hosts can load the plugin", got)
	}
}

func TestPluginRegistrationDeclaresOpenAIChatFormat(t *testing.T) {
	t.Parallel()

	caps := pluginRegistration().Capabilities
	for name, formats := range map[string][]string{"input": caps.ExecutorInputFormats, "output": caps.ExecutorOutputFormats} {
		found := false
		for _, format := range formats {
			if format == "openai" {
				found = true
			}
		}
		if !found {
			t.Fatalf("%s formats %v do not include openai", name, formats)
		}
	}
}
