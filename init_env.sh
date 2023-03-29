#!/usr/bin/env bash
oa_token=$(cat init.conf | grep oa_token | sed 's/oa_token = //')
cloud_id=$(cat init.conf | grep cloud_id | sed 's/cloud_id = //')
folder_id=$(cat init.conf | grep folder_id | sed 's/folder_id = //')
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ZONE=$(cat init.conf | grep zone | sed 's/zone = //')