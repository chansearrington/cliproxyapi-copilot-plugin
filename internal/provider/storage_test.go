package provider

import "testing"

func TestAuthDataDefaultsPrefixToCopilot(t *testing.T) {
	t.Parallel()

	storage := authStorage{Type: providerID, GitHubAccessToken: "gho_fake_test_token", GitHubLogin: "octo-user"}
	data, err := authData(storage, "", "", "", "", false, nil, nil)
	if err != nil {
		t.Fatalf("authData() error = %v", err)
	}
	if data.Prefix != "copilot" {
		t.Fatalf("Prefix = %q, want %q", data.Prefix, "copilot")
	}
	if data.ID != "copilot-octo-user.json" {
		t.Fatalf("ID = %q, want one credential per GitHub login", data.ID)
	}
}

func TestAuthDataKeepsExplicitPrefix(t *testing.T) {
	t.Parallel()

	storage := authStorage{Type: providerID, GitHubAccessToken: "gho_fake_test_token", GitHubLogin: "octo-user"}
	data, err := authData(storage, "", "", "team-a", "", false, nil, nil)
	if err != nil {
		t.Fatalf("authData() error = %v", err)
	}
	if data.Prefix != "team-a" {
		t.Fatalf("Prefix = %q, want the caller's explicit prefix", data.Prefix)
	}
}
