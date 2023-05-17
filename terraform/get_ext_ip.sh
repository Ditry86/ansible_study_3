#!/usr/bin/env 
[ -f ../playbook/ip ] && echo > ../playbook/ip || touch ../playbook/ip
terraform output | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![clickhouse]/,//d' | grep clickhouse | sed 's/[[:space:]]*clickhouse[[:space:]]*//g' >> ../playbook/ip
terraform output | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![lighthouse]/,//d' | grep lighthouse | sed 's/[[:space:]]*lighthouse[[:space:]]*//g' >> ../playbook/ip
terraform output | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![vector]/,//d' | grep vector | sed 's/[[:space:]]*vector[[:space:]]*//g' >> ../playbook/ip