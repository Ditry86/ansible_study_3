[ -f ~/.terraformrc ] && mv ~/.terraformrc ~/.terraformrc.old || touch ~/.terraformrc
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