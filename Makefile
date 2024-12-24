NIX_FLAGS := --quiet

SYS := $(shell nix $(NIX_FLAGS) eval --raw --impure --expr builtins.currentSystem)

# the names of all templates in this repository
TPLS := $(shell nix $(NIX_FLAGS) eval --json --no-write-lock-file .#templates |\
 jq -r keys[] \
| grep -v default \
| xargs -I % sh -c 'nix eval --raw --file flake.nix inputs.%.url 2>/dev/null && echo || echo %')

# the names of templates that should have package outputs
DEV_TPLS := $(filter-out tree-sitter,$(filter-out lean,$(filter-out empty,$(filter-out course,$(TPLS)))))

include ./ci.mk

.PHONY: test
all: ci test

.PHONY: test
test:
	# package output tests: check that packages.default builds and prints
	# "Hello, world!"
	for flake in $(DEV_TPLS); do \
	  nix $(NIX_FLAGS) build "git+file://$$PWD?dir=$${flake}/nix#packages.$(SYS).default" ;\
	  echo "checking $$flake output" ;\
	  diff <(result/bin/CHANGEME) <(echo "Hello, world!") || exit 1 ;\
	done
	# devshell tests: check that devShells.default builds
	for flake in $(TPLS); do \
	  echo "checking $$flake devshell" ;\
	  nix $(NIX_FLAGS) build "git+file://$$PWD?dir=$${flake}/nix#devShells.$(SYS).default" || exit 1 ;\
	done

.PHONY: update
update:
	for flake in $(TPLS); do \
	  nix $(NIX_FLAGS) flake update --flake "git+file://$$PWD?dir=$${flake}/nix" ;\
	done
	nix $(NIX_FLAGS) flake update --flake "git+file://$$PWD?dir=nix"

.PHONY: clean
clean:
	find . -name result -type l -delete
