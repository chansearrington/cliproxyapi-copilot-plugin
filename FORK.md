# FORK.md — why this fork exists

This is Chanse Arrington's fork of
[arthur-sommer-etc/cliproxyapi-copilot-plugin](https://github.com/arthur-sommer-etc/cliproxyapi-copilot-plugin),
used by the agent-os fleet, where CLIProxyAPI Home distributes it to macOS arm64 CPA nodes.

- `main` mirrors upstream; never commit here. Fleet changes live on `fleet`.
- Releases (`v0.3.4` onward) are tagged from `fleet` and publish two assets:
  `linux_amd64` (loaded inside Home on the Ark) and `darwin_arm64` (loaded by the nodes),
  plus `checksums.txt`. The macOS library is built on a GitHub `macos-15` runner, because a cgo
  shared library cannot be cross-compiled from Linux.

Patches carried on `fleet`, one commit each, offered upstream where general:

1. Declare registration schema 1 so Home's older embedded plugin host loads the plugin.
2. Stamp every credential with the prefix `copilot`, so models are `copilot/<id>` and
   (with the host's `force-model-prefix`) never pool with native providers.
3. Report GitHub's 402 (AI credits exhausted) to the host as 429 (quota cooldown).
4. Prefer Copilot's `/v1/messages` endpoint for Claude models (keeps thinking and caching).
5. `darwin/arm64` build, CI and release jobs, and a load test of every packaged library.

Workstream record: `docs/fleet/ws-0002-copilot-provider.md` in the fleet fork of
CLIProxyAPIHome.
