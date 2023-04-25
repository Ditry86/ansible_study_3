#!/usr/bin/env 
[ -f ../playbook/ext_ip ] && echo > ../playbook/ext_ip || touch ../playbook/ext_ip
terraform output | grep clickhouse | sed 's/[",=]//g' >> ../playbook/ext_ip
terraform output | grep vector | sed 's/[",=]//g' >> ../playbook/ext_ip
terraform output | grep lighthouse | sed 's/[",=]//g' >> ../playbook/ext_ip