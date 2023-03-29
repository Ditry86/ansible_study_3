SHELL:=/usr/bin/env bash

prepare: install env init_yc
cloud: cloud init_tf
vms: plan apply
deploy: 

install:
	source ./init_env.sh && source ./install_env.sh
init_yc: 
	source ./init_env.sh && yc init --token ${YC_TOKEN}
cloud:
	source ./init_cloud.sh

env:
	source ./init_env.sh

init_tf:
	source ./init_env.sh && cd ./terraform && terraform init 

plan: 
	source ./init_env.sh && cd ./terraform && terraform plan -out=terraform.tfplan

apply: 
	source ./init_env.sh && cd ./terraform && terraform apply -auto-approve

destroy: 
	source ./init_env.sh && source ./destroy.sh

get_ip:
	source ./get_ext_ip.sh