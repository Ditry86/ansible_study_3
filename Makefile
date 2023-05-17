SHELL:=/usr/bin/env bash

export YC_OA_TOKEN := $(shell cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD_ID := $(shell cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER_ID := $(shell cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_ACCOUNT := $(shell cat init.conf | grep service_account | sed 's/service_account = //')
export TF_VAR_zone := $(shell cat init.conf | grep zone | sed 's/zone = //')
export CLICKHOUSE_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep clickhouse | sed 's/[[:space:]]*clickhouse[[:space:]]*//')
export VECTOR_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep vector | sed 's/[[:space:]]*vector[[:space:]]*//')
export LIGHTHOUSE_IP=$(shell cat playbook/ext_ip 2> /dev/null | grep lighthouse | sed 's/[[:space:]]*lighthouse[[:space:]]*//')


prepare: cloud tf_init
deploy: tf_plan tf_apply
cicd: get_ip play 

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
	@cd terraform && source get_ext_ip.sh
	
play:
	@export ANSIBLE_HOST_KEY_CHECKING=False && cd playbook/ && ansible-playbook site.yml -i inventory/prod.yml -vvv
