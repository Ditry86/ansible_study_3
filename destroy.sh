#!/usr/bin/env bash
cd ./terraform
terraform destroy -auto-approve
cd ..
yc config profile activate default && yc config profile delete $(cat init.conf | grep service_account | sed 's/service_account = //')
yc iam service-account delete --name $(cat init.conf | grep service_account | sed 's/service_account = //')

rm -rf terraform/.terraform*
rm -rf terraform/terraform*
rm key.json
unset "${!YC@}"
echo $'\n'I did it!$'\n'