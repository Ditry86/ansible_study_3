variable "yc_folder_id" {
    default=""
}

variable "yc_token" {
    default=""
}

variable "yc_cloud_id" {
    default=""
}

variable "yc_zone" {
    default=""
}

locals {
    
    lans = {
        default = ["192.168.10.0/24"]
    }

    instances = { 
        "clickhouse" = {
            platform = "standard-v2",
            cores = 4,
            memory = 4
        },
        "vector" = {
            platform = "standard-v2",
            cores = 2,
            memory = 2
        },
        "lighthouse" = {
            platform = "standard-v1",
            cores = 2,
            memory = 2
        },
    }
}

output "external_ip_address" {
    value = {for k, v in yandex_compute_instance.netology_ansible_03: k => v.network_interface.0.nat_ip_address}
}