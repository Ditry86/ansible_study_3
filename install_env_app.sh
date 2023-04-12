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
cur_dir=$(pwd)
passwd='' 
distro=$(cat /etc/os-release | grep ^ID= | sed -e 's/ID=["]*//;s/["]*$//')
#Promt sudo password
if [[ $tf != 0 ]] || [[ $py != 0 ]] || [[ $an != 0 ]] 
then
    echo Type your sudo password:' '
    read -s $passwd
    case $distro in
        ubuntu | Ubuntu )
            echo $passwd | sudo apt update && sudo apt upgrade -y
            ;;
        centos | Centos | CentOs | CentOS)
            echo $passwd | sudo yum update && sudo yum upgrade -y
            ;;
    esac
    mkdir $cur_dir/tmp
    cd ~/tmp 
else
    [ $yc == 0 ] && echo $'\n'Nothing needs to do$'\n'
fi

if [ $yc != 0 ]; then
#Install yc
        echo $'\n'Installed Yandex CLI...$'\n'==============================================================$'\n'
        curl -L https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -a
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
#Install terraform from yandex mirror
if  [ $tf != 0 ]; then
    echo $'\n'Installed Terraform...$'\n'==============================================================$'\n'
    case $distro in
        ubuntu | Ubuntu )
            echo $passwd | sudo apt install -y unzip
            ;;
        centos | Centos | CentOs | CentOS)
            echo $passwd | sudo yum install -y unzip
            ;;
    esac
    curl -L -k https://hashicorp-releases.yandexcloud.net/terraform/1.4.2/terraform_1.4.2_linux_amd64.zip > terraform.zip
    echo passwd | sudo unzip -d /usr/local/bin terraform.zip
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
#Install python3
if  [ $py != 0 ]; then
    echo $'\n'Installed Python3...$'\n'==============================================================$'\n'
    case $distro in
        ubuntu | Ubuntu )
            echo $passwd | sudo apt install -y python3 python3-dev
            ;;
        centos | Centos | CentOs | CentOS)
            echo $passwd | sudo yum install -y python3 python3-devel
            ;;
    esac
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
#Install ansible 
if  [ $an != 0 ]; then
    echo $'\n'Installed Ansible '(by using pip)'...$'\n'==============================================================$'\n'
    which pip3 > /dev/null
    if [ "$distro" == "ubuntu" ] || [ "$distro" == "Ubuntu" ]; then
        echo $passwd | sudo apt install python3-pip
    fi
    echo $passwd | sudo python3 -m pip install --upgrade pip
    echo $passwd | sudo python3 -m pip install --user netaddr
    python3 -m pip install --upgrade --user ansible
    echo $HOME
    echo $passwd | sudo echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
    source ~/.bashrc
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
cd $cur_dir
[ -d "$cur_dir/tmp" ] && sudo rm -rf "$cur_dir/tmp"
cur_bash_id=$$
exec /usr/bin/bash
kill -9 $cur_bash_id