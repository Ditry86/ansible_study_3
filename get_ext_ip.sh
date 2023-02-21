#!/usr/bin/env bash
cd terraform
export CLICKHOUSE_IP=$(terraform output | grep clickhouse | sed 's/\s*"clickhouse" = "//;s/"$//')
export VECTOR_IP=$(terraform output | grep vector | sed 's/\s*"vector" = "//;s/"$//')
export LIGHTHOUSE_IP=$(terraform output | grep lighthouse | sed 's/\s*"lighthouse" = "//;s/"$//')
cd ..