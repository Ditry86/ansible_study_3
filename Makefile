SHELL:=/usr/bin/env bash

prepare: install env-var
cloud: cloud init_tf
vms: plan apply

install:
	source install_env_app.sh 

env-var: 
	source init_env_var.sh
	
cloud:
	source init_cloud.sh

init_tf:
	cd ./terraform && source terraform init 

plan: 
	cd ./terraform && terraform plan -out=terraform.tfplan

apply: 
	cd ./terraform && terraform apply -auto-approve

destroy: 
	source destroy.sh

get_ip:
	source get_ext_ip.sh