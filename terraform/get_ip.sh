#!/usr/bin/env 
[ -f ../playbook/local_ip ] && echo > ../playbook/local_ip || touch ../playbook/local_ip
[ -f ../playbook/ext_ip ] && echo > ../playbook/ext_ip || touch ../playbook/ext_ip
terraform output > ./tf_out
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![clickhouse]/,//d' | grep clickhouse | sed 's/^[[:space:]]*//' >> ../playbook/local_ip
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![lighthouse]/,//d' | grep lighthouse | sed 's/^[[:space:]]*//' >> ../playbook/local_ip
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![vector]/,//d' | grep vector | sed 's/^[[:space:]]*//' >> ../playbook/local_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![clickhouse]/,//d' | grep clickhouse | sed 's/^[[:space:]]*//' >> ../playbook/ext_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![lighthouse]/,//d' | grep lighthouse | sed 's/^[[:space:]]*//' >> ../playbook/ext_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![vector]/,//d' | grep vector | sed 's/^[[:space:]]*//' >> ../playbook/ext_ip

