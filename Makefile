SHELL:=/usr/bin/env bash

export YC_OA_TOKEN=$(shell cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD_ID=$(shell cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER_ID=$(shell cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_ACCOUNT=$(shell cat init.conf | grep service_account | sed 's/service_account = //')
export YC_ZONE=$(shell cat init.conf | grep zone | sed 's/zone = //')

prepare: install cloud tf_init
init: cloud tf_init
deploy: tf_plan tf_apply playbook

install:
	source install_env_app.sh
	source ~/.bashrc
	
cloud:
	source init_cloud.sh
	@export YC_TOKEN=$(shell yc iam create-token)

tf_init:	
	@cd terraform && terraform init 

tf_plan: 
	@cd terraform && terraform plan -out=terraform.tfplan

tf_apply: 
	@cd terraform && terraform apply -auto-approve
	echo $(shell pwd)
	CLICKHOUSE_IP=$(shell terraform output -state=./terraform/terraform.tfstate | grep clickhouse | sed 's/\s*"clickhouse" = "//;s/"$//')
	echo $(CLICKHOUSE_IP) 
	@cd terraform && export VECTOR_IP=$(shell terraform output | grep vector | sed 's/\s*"vector" = "//;s/"$//')
	@echo $(VECTOR_IP) >> ./init.conf
	@cd terraform && export LIGHTHOUSE_IP=$(shell terraform output | grep lighthouse | sed 's/\s*"lighthouse" = "//;s/"$//')
	@echo $(LIGHTHOUSE_IP) >> ./init.conf

destroy: 
	@source destroy.sh

get_ip:
	@export CLICKHOUSE_IP=$(shell cat init.conf | grep clickhouse | sed 's/\s*"clickhouse" = "//;s/"$//')
	@export VECTOR_IP=$(shell cat init.conf | grep vector | sed 's/\s*"vector" = "//;s/"$//')
	@export LIGHTHOUSE_IP=$(shell cat init.conf | grep lighthouse | sed 's/\s*"lighthouse" = "//;s/"$//')

playbook:
	cd playbook && ansible-playbook site.yml -i inventory/prod.yml
	echo --------------------------------------------------------------$'\n'Done!$'\n'
