#!/usr/bin/env bash


cur_dir=$(pwd)
if [ -f "${cur_dir}/key.json" ]; then
    echo The cloud is already initiated and prepared
else
    echo $'\n'Set yc...
    yc config set token ${YC_OA_TOKEN}
    serv_acc_id=$(yc iam service-account create ${YC_ACCOUNT} --folder-id ${YC_FOLDER_ID} | grep ^id: | sed 's/id: //')
    yc resource-manager folder add-access-binding default --role="admin" --subject="serviceAccount:${serv_acc_id}"
    yc iam key create --service-account-id ${serv_acc_id} --output key.json 
    yc config profile create ${YC_ACCOUNT}
    yc config set service-account-key key.json
    yc config set cloud-id ${YC_CLOUD_ID}
    yc config set folder-id ${YC_FOLDER_ID}
    yc config profile activate ${YC_ACCOUNT}
fi
[ -f ./id_ed25519.pub ] || ssh-keygen -t ed25519 -f ./id_ed25519.pub -N '' -Y > /dev/null