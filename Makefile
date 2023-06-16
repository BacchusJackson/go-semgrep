BIN="./bin"
SRC=$(shell find . -name "*.go")

ifeq (, $(shell which richgo))
$(warning "could not find richgo in $(PATH), run: go install github.com/kyoh86/richgo@latest")
endif

ifeq (, $(shell which gojsonschema))
$(warning "could not find gojsonschema in $(PATH), run: go install github.com/atombender/go-jsonschema/cmd/gojsonschema@latest")
endif

.PHONY: tool_deps juice-shop-scan schema-to-go test install_deps

juice-shop-scan:
	git clone https://github.com/juice-shop/juice-shop.git juice-shop
	docker run --rm -v "${PWD}/juice-shop:/src" returntocorp/semgrep semgrep --config=auto --json > juice-shop-semgrep-scan.json

schema-to-go: 
	gojsonschema -p go_semgrep semgrep-interfaces/semgrep_output_v1.jsonschema > semgrep.go

test: install_deps
	$(info ******************** running tests ********************)
	richgo test -v ./...

install_deps:
	$(info ******************** downloading dependencies ********************)
	go get -v ./...

clean:
	rm -rf juice-shop

	# cat juice-shop-sast-scan.json | json-to-struct -name Semgrep -pkg go_semgrep > $@
