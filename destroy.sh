#!/usr/bin/env bash
cd ./terraform
terraform destroy -auto-approve
cd ..
yc config profile activate default
yc config profile delete ${YC_ACCOUNT}
yc iam service-account delete ${YC_ACCOUNT} --folder-id ${YC_FOLDER_ID}

rm -rf terraform/.terraform*
rm -rf terraform/terraform*
rm key.json
rm playbook/ext_ip
rm token
rm *.pub
unset "${!YC@}"
echo $'\n'I did it!$'\n'