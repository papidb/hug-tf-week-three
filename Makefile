SHELL := /bin/bash

-include .env
export

AWS_PROFILE ?= terraform-lab
ENVIRONMENT ?= dev
TERRAFORM ?= terraform
SSH_PUBLIC_KEY_FILE ?= $(HOME)/.ssh/id_ed25519.pub

.PHONY: bootstrap-init bootstrap-apply backend-init setup fmt validate plan apply deploy verify destroy destroy-backend destroy-all

bootstrap-init:
	AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) -chdir=bootstrap init

bootstrap-apply: bootstrap-init
	AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) -chdir=bootstrap apply

backend-init: bootstrap-apply
	@bucket=$$(AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) -chdir=bootstrap output -raw state_bucket_name); \
	test -n "$$bucket"; \
	AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) init \
		-reconfigure \
		-backend-config="bucket=$$bucket"

setup: backend-init

fmt:
	$(TERRAFORM) fmt -recursive

validate:
	$(TERRAFORM) validate

plan: fmt validate
	@set -eu; \
	test -n "$(TF_VAR_db_password)" || { echo "TF_VAR_db_password is not set (add it to .env)"; exit 1; }; \
	test -f "$(SSH_PUBLIC_KEY_FILE)" || { echo "SSH public key not found at $(SSH_PUBLIC_KEY_FILE)"; exit 1; }; \
	ip=$$(curl -fsS https://checkip.amazonaws.com); \
	cidr=$$(echo "$$ip" | awk -F. '{print $$1"."$$2"."$$3".0/24"}'); \
	AWS_PROFILE=$(AWS_PROFILE) TF_VAR_ssh_cidr="$$cidr" TF_VAR_environment="$(ENVIRONMENT)" \
	TF_VAR_public_key="$$(cat $(SSH_PUBLIC_KEY_FILE))" \
	$(TERRAFORM) plan -out=tfplan

apply:
	AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) apply tfplan

deploy:
	$(MAKE) plan
	$(MAKE) apply

verify:
	@ip=$$(AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) output -raw instance_public_ip); \
	echo "Testing http://$$ip"; \
	curl --fail --show-error "http://$$ip"

destroy:
	@set -eu; \
	test -n "$(TF_VAR_db_password)" || { echo "TF_VAR_db_password is not set (add it to .env)"; exit 1; }; \
	ip=$$(curl -fsS https://checkip.amazonaws.com); \
	cidr=$$(echo "$$ip" | awk -F. '{print $$1"."$$2"."$$3".0/24"}'); \
	AWS_PROFILE=$(AWS_PROFILE) TF_VAR_ssh_cidr="$$cidr" TF_VAR_environment="$(ENVIRONMENT)" \
	TF_VAR_public_key="$$(cat $(SSH_PUBLIC_KEY_FILE) 2>/dev/null || true)" \
	$(TERRAFORM) destroy

destroy-backend:
	@resources=$$(AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) state list 2>/dev/null || true); \
	if [ -n "$$resources" ]; then \
		echo "Application resources still exist. Run 'make destroy' first."; \
		exit 1; \
	fi; \
	AWS_PROFILE=$(AWS_PROFILE) $(TERRAFORM) -chdir=bootstrap destroy

destroy-all:
	$(MAKE) destroy
	$(MAKE) destroy-backend
