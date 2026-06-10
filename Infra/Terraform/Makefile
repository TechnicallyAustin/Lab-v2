ENV ?= dev
DIR  = environments/$(ENV)

.PHONY: init plan apply destroy fmt validate diagrams

init:
	terraform -chdir=$(DIR) init

plan:
	terraform -chdir=$(DIR) plan -out=$(DIR)/tfplan

apply:
	terraform -chdir=$(DIR) apply $(DIR)/tfplan

destroy:
	terraform -chdir=$(DIR) destroy

fmt:
	terraform fmt -recursive

validate:
	terraform -chdir=$(DIR) validate

diagrams:
	node generate-diagrams.js
