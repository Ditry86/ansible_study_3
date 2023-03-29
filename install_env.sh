#!/usr/bin/env bash

#Check installed utils
which terraform > /dev/null
tf=$?
which yc > /dev/null
yc=$?
which python3 > /dev/null
py=$?
which ansible > /dev/null
an=$?
passwd='' 
#Promt sudo password
if [[ $tf != 0 ]] || [[ $py != 0 ]] || [[ $an != 0 ]] 
then
    echo Type your sudo password:' '
    read -s $passwd
    mkdir ~/tmp
    cd ~/tmp
elif [ $yc != 0 ]; then
#Install yc
    echo $'\n'Installed Yandex CLI...$'\n'==============================================================$'\n'
    curl -L https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -a
    echo --------------------------------------------------------------$'\n'Done!$'\n'
else
    echo $'\n'Nothing needs to do$'\n'
fi
#Install terraform from yandex mirror
if  [ $tf != 0 ]; then
    echo $'\n'Installed Terraform...$'\n'==============================================================$'\n'
    curl -L https://hashicorp-releases.yandexcloud.net/terraform/1.4.2/terraform_1.4.2_linux_amd64.zip > terraform.zip
    echo passwd | sudo unzip -d /usr/local/bin terraform.zip
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
#Install python3
if  [ $py != 0 ]; then
    echo $'\n'Installed Python3...$'\n'==============================================================$'\n'
    distro=$(cat /etc/os-release | grep ^ID= | sed -e 's/ID=["]*//;s/["]*$//')
    case $distro in
        ubuntu)
            echo $passwd | sudo apt install -y python3 python3-dev
            ;;
        centos)
            echo $passwd | sudo yum install -y python3 python3-devel
            ;;
    esac
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
#Install ansible 
if  [ $an != 0 ]; then
    echo $'\n'Installed Ansible '(by using pip)'...$'\n'==============================================================$'\n'
    python3 -m pip install --upgrade pip
    python3 -m pip install --upgrade --user ansible
    python3 -m pip install --user netaddr
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
[ -d "$HOME/tmp" ] && rm -r "$HOME/tmp" 
