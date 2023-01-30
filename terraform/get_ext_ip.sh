#!/usr/bin/env bash
export CLICKHOUSE_IP=$(terraform output | grep clickhouse | sed 's/"clickhouse" = "//;s/"$//')
export VECTOR_IP=$(terraform output | grep vector | sed 's/"vector" = "//;s/"$//')
export LIGHTHOUSE_IP=$(terraform output | grep lighthouse | sed 's/"lighthouse" = "//;s/"$//')