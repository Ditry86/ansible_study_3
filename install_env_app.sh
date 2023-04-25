#!/usr/bin/env bash
set -Eeuo pipefail
#Check required apps 
echo $'\n'Check required apps 
echo ==============================================================$'\n'
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
stop=0
#Promt sudo password (if needed)
if [[ $tf != 0 ]] || [[ $py != 0 ]] || [[ $an != 0 ]] 
then
    echo Type your sudo password:' '
    read -s $passwd
        ubuntu | Ubuntu )
            echo $'\n'apt cache update and upgrade packets...$'\n'
            echo $passwd | sudo apt update > /dev/null && sudo apt upgrade -y > /dev/null
            ;;
        centos | Centos | CentOs | CentOS)
            echo $'\n'yum cache update and upgrade packets...$'\n'
            echo $passwd | sudo yum update > /dev/null && sudo yum upgrade -y > /dev/null
            ;;
    esac
    mkdir tmp
    cd tmp 
else
    stop=1
    [ $yc == 0 ] && echo --------------------------------------------------------------$'\n'Nothing needs to do$'\n'--------------------------------------------------------------$'\n'
fi
if [ $stop == 0 ]; then
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
                echo Installed unzip...$'\b'
                echo $passwd | sudo apt install -y unzip > /dev/null
                [ $? == 0] && echo Done$'\n'
                ;;
            centos | Centos | CentOs | CentOS)
                echo Installed unzip...$'\b'
                echo $passwd | sudo yum install -y unzip > /dev/null
                [ $? == 0] && echo Done$'\n'
                ;;
        esac
        curl -L -k https://hashicorp-releases.yandexcloud.net/terraform/1.4.2/terraform_1.4.2_linux_amd64.zip > terraform.zip
        echo $passwd | sudo unzip -d /usr/local/bin terraform.zip
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
    #Install python3
    if  [ $py != 0 ]; then
        echo $'\n'Installed Python3...$'\n'==============================================================$'\n'

        case $distro in
            ubuntu | Ubuntu )
                echo $passwd | sudo apt install -y python3
                ;;
            centos | Centos | CentOs | CentOS)
                echo $passwd | sudo yum install -y python3
                ;;
        esac
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
    #Install ansible 
    if  [ $an != 0 ]; then
        #Instal python3 depends packages
        echo $'\n'Installed Ansible '(by using pip)'...$'\n'==============================================================$'\n'
        case $distro in
            ubuntu | Ubuntu )
                echo $passwd | sudo apt install -y python3 python3-dev python3-pip 
                ;;
            centos | Centos | CentOs | CentOS )
                echo $passwd | sudo yum install -y epel-release
                echo $passwd | sudo yum install -y python3 python3-devel python3-pip 
                ;;
        esac
        echo $passwd | sudo python3 -m pip install --upgrade pip 
        echo $passwd | sudo python3 -m pip install --user netaddr 
        python3 -m pip install --upgrade --user ansible 
        echo $passwd | sudo echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
    cd $cur_dir
    [ -d "$cur_dir/tmp" ] && $(cd $cur_dir && sudo rm -rf "$cur_dir/tmp") || echo $'\n'$cur_dir/tmp is not exist$'\n'
    echo --------------------------------------------------------------$'\n'Installation completed successfully$'\n'
fi