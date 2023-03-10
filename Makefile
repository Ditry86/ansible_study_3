SHELL:=/usr/bin/env bash
prepare: cloud init

start: plan apply


cloud:
	source ./init_cloud.sh

env:
	source ./reinit_env.sh

init:
	source ./reinit_env.sh && cd ./terraform && terraform init 

plan: 
	source ./reinit_env.sh && cd ./terraform && terraform plan -out=terraform.tfplan

apply: 
	source ./reinit_env.sh && cd ./terraform && terraform apply -auto-approve

destroy: 
	source ./reinit_env.sh && source ./destroy.sh

get_ip:
	source ./get_ext_ip.sh