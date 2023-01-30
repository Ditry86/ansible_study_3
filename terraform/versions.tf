terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}
data "yandex_compute_image" "centos7" {
  family = "centos-7"
}