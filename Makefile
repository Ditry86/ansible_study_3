SHELL:=/usr/bin/env bash

export YC_OA_TOKEN := $(shell cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD_ID := $(shell cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER_ID := $(shell cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_ACCOUNT := $(shell cat init.conf | grep service_account | sed 's/service_account = //')
export TF_VAR_zone := $(shell cat init.conf | grep zone | sed 's/zone = //')
export CLICKHOUSE_EXT_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep clickhouse | sed 's/clickhouse[[:space:]]*//')
export VECTOR_EXT_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep vector | sed 's/vector[[:space:]]*//')
export LIGHTHOUSE_EXT_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep lighthouse | sed 's/lighthouse[[:space:]]*//')
export CLICKHOUSE_LOCAL_IP=$(shell cat playbook/local_ip 2> /dev/null | grep clickhouse | sed 's/clickhouse[[:space:]]*//')
export VECTOR_LOCAL_IP=$(shell cat playbook/local_ip 2> /dev/null | grep vector | sed 's/vector[[:space:]]*//')
export LIGHTHOUSE_LOCAL_IP=$(shell cat playbook/local_ip 2> /dev/null | grep lighthouse | sed 's/lighthouse[[:space:]]*//')


prepare: cloud tf_init
deploy: tf_plan tf_apply
ci: get_ip play help

install:
	@source install_env_app.sh
	
cloud:
	@source $(HOME)/.bashrc && ./init_cloud.sh

tf_init:
	@source ./tf_provider_mirror.sh	
	@cd terraform && terraform init 

tf_plan: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform plan -out=terraform.tfplan

tf_apply: 
	@export YC_TOKEN=$(shell cat ./token) && cd terraform && terraform apply -auto-approve terraform.tfplan 

destroy: 
	@source $(HOME)/.bashrc && export YC_TOKEN=$(shell cat ./token) && source destroy.sh

get_ip:
	@cd terraform && source get_ip.sh

play:
	@source playbook/prepare_ansible.sh
	@export ANSIBLE_HOST_KEY_CHECKING=False && cd playbook/ && ansible-playbook site.yml -i inventory/prod.yml

help:
	@echo Your VM IP adresses:
	@echo ""
	@cd terraform && terraform output
