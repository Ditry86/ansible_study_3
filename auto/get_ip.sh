#!/usr/bin/env 
[ -f ./local_ip ] && echo > ./local_ip || touch ./local_ip
[ -f ./ext_ip ] && echo > ./ext_ip || touch ./ext_ip
cd terraform/ && terraform output > ../tf_out
cd ..
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![clickhouse]/,//d' | grep clickhouse | sed 's/^[[:space:]]*//' >> local_ip
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![lighthouse]/,//d' | grep lighthouse | sed 's/^[[:space:]]*//' >> local_ip
cat tf_out | sed '/local.*/,/}/!d;//d;s/[",=]//g;/![vector]/,//d' | grep vector | sed 's/^[[:space:]]*//' >> local_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![clickhouse]/,//d' | grep clickhouse | sed 's/^[[:space:]]*//' >> ext_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![lighthouse]/,//d' | grep lighthouse | sed 's/^[[:space:]]*//' >> ext_ip
cat tf_out | sed '/external.*/,/}/!d;//d;s/[",=]//g;/![vector]/,//d' | grep vector | sed 's/^[[:space:]]*//' >> ext_ip

