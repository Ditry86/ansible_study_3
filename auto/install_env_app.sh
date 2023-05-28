#!/usr/bin/env bash
set -Euo pipefail
#Check required apps 
echo $'\n'==============================================================
echo Checking required apps 
echo ==============================================================$'\n'
which terraform &> /dev/null
tf=$?
which yc &> /dev/null
yc=$?
which python3 &> /dev/null
py=$?
which ansible &> /dev/null
an=$?
which curl &> /dev/null
cu=$?
passwd='' 
distro=$(cat /etc/os-release | grep ^ID= | sed -e 's/ID=["]*//;s/["]*$//')
stop=0
#Promt sudo password (if needed)
if [[ $tf != 0 ]] || [[ $py != 0 ]] || [[ $an != 0 ]] || [[ $cu != 0 ]]
then
    echo Found uninstalled software...
    echo --------------------------------------------------------------$'\n'
    echo Type your sudo password:$'\n'
    read -s $passwd
    case $distro in
        ubuntu | Ubuntu )
            echo $'\n'apt cache update and upgrade packets...$'\n'
            echo $passwd | sudo apt upgrade -y > /dev/null 
            ;;
        centos | Centos | CentOs | CentOS )
            echo $'\n'yum cache update and upgrade packets...$'\n'
            echo $passwd | sudo yum upgrade -y > /dev/null 
            ;;
    esac
    mkdir tmp
    cd tmp 
else
    stop=1
    [ $yc == 0 ] && echo $'\n'All required software is installed!$'\n'--------------------------------------------------------------$'\n'
fi
#Install yc
if [ $yc != 0 ]; then
    echo $'\n'==============================================================
    echo Install Yandex CLI...
    echo ==============================================================$'\n'
    curl -L https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash -s -- -a
    echo --------------------------------------------------------------$'\n'Done!$'\n'
fi
if [ $stop == 0 ]; then
    if [ $cu != 0 ]; then
        echo $passwd | sudo apt install -y curl > /dev/null
                [ $? == 0] && echo Done$'\n'
    fi
    #Install terraform from yandex mirror
    if  [ $tf != 0 ]; then
        echo $'\n'==============================================================
        echo Install Terraform...
        echo ==============================================================$'\n'
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
        echo $'\n'==============================================================
        echo Install Python3...
        echo ==============================================================$'\n'

        case $distro in
            ubuntu | Ubuntu )
                echo $passwd | sudo apt install -y python3 python3-dev python3-pip 
                ;;
            centos | Centos | CentOs | CentOS)
                echo $passwd | sudo yum install -y epel-release
                echo $passwd | sudo yum install -y python3 python3-dev python3-pip 
                ;;
        esac
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
    #Install ansible 
    if  [ $an != 0 ]; then
        #Instal python3 depends packages
        echo $'\n'==============================================================
        echo Install Ansible...
        echo ==============================================================$'\n'
        case $distro in
            ubuntu | Ubuntu )
                echo $passwd | sudo apt install -y ansible
                
                ;;
            centos | Centos | CentOs | CentOS )
                echo $passwd | sudo yum install -y epel-release
                echo $passwd | sudo yum install -y ansible
                ;;
        esac
        if [ $(which pip > /dev/null) != 0 ]; then 
            case $distro in
                ubuntu | Ubuntu )
                    echo $passwd | sudo python3 -m pip install --upgrade pip
                    ;;
                centos | Centos | CentOs | CentOS )
                    echo $passwd | sudo python3 -m pip install --upgrade pip
                    ;;
            esac
        fi
        echo $passwd | sudo python3 -m pip install --upgrade pip 
        echo $passwd | sudo python3 -m pip install netaddr 
        echo $passwd | sudo echo 'export PATH=$PATH:~/.local/bin' >> ~/.bashrc
        echo --------------------------------------------------------------$'\n'Done!$'\n'
    fi
    [ -d "tmp/" ] && $(echo $passwd | sudo rm -rf "tmp/") || echo $'\n'tmp/ is not exist$'\n'
    echo --------------------------------------------------------------$'\n'Installation completed successfully$'\n'
fi