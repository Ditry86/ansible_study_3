export YC_TOKEN=$(cat init.conf | grep oa_token | sed 's/oa_token = //')
export YC_CLOUD=$(cat init.conf | grep cloud_id | sed 's/cloud_id = //')
export YC_FOLDER=$(cat init.conf | grep folder_id | sed 's/folder_id = //')