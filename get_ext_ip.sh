#!/usr/bin/env bash
cd terraform
export CLICKHOUSE_IP=$(terraform output | grep clickhouse | sed 's/\s*"clickhouse" = "//;s/"$//') >> ../ext_ip
export VECTOR_IP=$(terraform output | grep vector | sed 's/\s*"vector" = "//;s/"$//') >> ../ext_ip
export LIGHTHOUSE_IP=$(terraform output | grep lighthouse | sed 's/\s*"lighthouse" = "//;s/"$//') >> ../ext_ip
cd ..