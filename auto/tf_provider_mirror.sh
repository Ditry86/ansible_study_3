#!/usr/bin/env bash
echo Type your sudo password:' '
read -s $passwd
[ -f ${HOME}/.terraformrc ] && echo $passwd | mv ~/.terraformrc ~/.terraformrc.old 
echo $passwd | touch ~/.terraformrc
cat << EOF >> ~/.terraformrc
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
EOF