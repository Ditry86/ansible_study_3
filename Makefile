SHELL:=/usr/bin/env bash

export YC_OA_TOKEN := $(shell cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD_ID := $(shell cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER_ID := $(shell cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_ACCOUNT := $(shell cat init.conf | grep service_account | sed 's/service_account = //')
export TF_VAR_zone := $(shell cat init.conf | grep zone | sed 's/zone = //')

prepare: cloud tf_init
init: cloud tf_init
deploy: tf_plan tf_apply 

install:
	@source install_env_app.sh
	@source $(HOME)/.bashrc
	
cloud:
	@source $(HOME)/.bashrc
	@source init_cloud.sh

tf_init:
	@source tf_provider_mirror.sh	
	@cd terraform && terraform init 

tf_plan: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform plan -out=terraform.tfplan

tf_apply: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform apply -auto-approve terraform.tfplan && ./get_ext_ip.sh

destroy: 
	@export YC_TOKEN=$(shell cat ./token) && source destroy.sh

get_ip:
	@export CLICKHOUSE_IP=$(shell cat ext_ip | grep clickhouse | sed 's/\s*"clickhouse" = "//;s/"$//')
	@export VECTOR_IP=$(shell cat ext_ip | grep vector | sed 's/\s*"vector" = "//;s/"$//')
	@export LIGHTHOUSE_IP=$(shell cat ext_ip | grep lighthouse | sed 's/\s*"lighthouse" = "//;s/"$//')

playbook:
	cd playbook && ansible-playbook site.yml -i inventory/prod.yml
	echo --------------------------------------------------------------$'\n'Done!$'\n'
