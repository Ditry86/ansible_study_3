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
