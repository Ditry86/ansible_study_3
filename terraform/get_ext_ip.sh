#!/usr/bin/env 
touch ../ansible/ext_ip
terraform output | grep clickhouse | sed 's/[",=]//g' >> ../ansible/ext_ip
terraform output | grep vector | sed 's/[",=]//g' >> ../ansible/ext_ip
terraform output | grep lighthouse | sed 's/[",=]//g' >> ../ansible/ext_ip