#!/usr/bin/env bash
tf=0
yc=0
which terraform
[[ tf==1 ]] && echo $tf
[[ $(which yc) != 0 ]] && yc=1 && echo $yc
#[[ $tf==1 || yc==1 ]] && [ "$UID" != 0 ] && exec sudo -- "$0" "$@"
mkdir ~/tmp/
cd ~/tmp/
#Install terraform
if [[ $tf==1 ]]; then sta
    echo $'\n'Install Terraform...$'\n'===========================================$'\n'
    #curl -L -o terraform.zip https://hashicorp-releases.yandexcloud.net/terraform/1.4.2/terraform_1.4.2_linux_amd64.zip
    #sudo unzip terraform.zip -d /usr/local/bin
fi
#Install yc
if [[ $yc==1 ]]; then 
    echo $'\n'Install Yandex CLI...$'\n'===========================================$'\n'
    #curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -- -a
fi
[[ $(which python3) == 0 ]] && py_vers=$(python3 -V | egrep -o '[0-9]{2}') || py_vers="old"
echo $py_vers
rm -rf ~/tmp