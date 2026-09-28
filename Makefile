GO_IMAGE ?= golang:1.26-bookworm
VERSION ?= 0.3.4
PLUGIN_DIR := build/plugins/linux/amd64
PLUGIN_SO := $(PLUGIN_DIR)/cliproxyapi-copilot.so
CACHE_DIR := .cache
VERSION_LDFLAG := -X main.pluginVersion=$(VERSION)

.PHONY: test build build-local build-darwin-arm64 package package-darwin-arm64 clean

test:
	go test ./...

build:
	mkdir -p $(PLUGIN_DIR) $(CACHE_DIR)/go-build $(CACHE_DIR)/go-mod $(CACHE_DIR)/home
	docker run --rm \
		--user "$$(id -u):$$(id -g)" \
		-e HOME=/src/$(CACHE_DIR)/home \
		-e GOCACHE=/src/$(CACHE_DIR)/go-build \
		-e GOMODCACHE=/src/$(CACHE_DIR)/go-mod \
		-v "$(CURDIR):/src" \
		-w /src \
		$(GO_IMAGE) \
		sh -ec 'CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -buildvcs=false -trimpath -ldflags "$(VERSION_LDFLAG)" -buildmode=c-shared -o $(PLUGIN_SO) ./cmd/cliproxyapi-copilot'

build-local:
	mkdir -p $(PLUGIN_DIR)
	CGO_ENABLED=1 GOOS=linux GOARCH=amd64 go build -buildvcs=false -trimpath -ldflags "$(VERSION_LDFLAG)" -buildmode=c-shared -o $(PLUGIN_SO) ./cmd/cliproxyapi-copilot

build-darwin-arm64:
	@test "$$(go env GOOS)" = "darwin" || \
		{ echo "error: build-darwin-arm64 requires a macOS host (cgo c-shared cannot cross-compile)" >&2; exit 1; }
	mkdir -p build/plugins/darwin/arm64
	CGO_ENABLED=1 GOOS=darwin GOARCH=arm64 go build -buildvcs=false -trimpath -ldflags "$(VERSION_LDFLAG)" -buildmode=c-shared -o build/plugins/darwin/arm64/cliproxyapi-copilot.dylib ./cmd/cliproxyapi-copilot

package: build
	scripts/package-release.sh "$(VERSION)" linux amd64

package-darwin-arm64: build-darwin-arm64
	scripts/package-release.sh "$(VERSION)" darwin arm64

clean:
	rm -rf build dist $(CACHE_DIR)
