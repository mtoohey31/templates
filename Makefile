.PHONY: update

update:
	for flake in $$(nix eval --json .#templates | jq -r 'keys[]'); do \
	  test -d "$$flake" && nix flake update "./$${flake}#" ;\
	done
