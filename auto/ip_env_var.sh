#!/usr/bin/env bash

export CLICKHOUSE_EXT_IP=$(cat ext_ip 2> /dev/null | grep clickhouse | sed 's/clickhouse[[:space:]]*//')
export VECTOR_EXT_IP=$(cat ext_ip 2> /dev/null | grep vector | sed 's/vector[[:space:]]*//')
export LIGHTHOUSE_EXT_IP=$(cat ext_ip 2> /dev/null | grep lighthouse | sed 's/lighthouse[[:space:]]*//')
export CLICKHOUSE_LOCAL_IP=$(cat local_ip 2> /dev/null | grep clickhouse | sed 's/clickhouse[[:space:]]*//')
export VECTOR_LOCAL_IP=$(cat local_ip 2> /dev/null | grep vector | sed 's/vector[[:space:]]*//')
export LIGHTHOUSE_LOCAL_IP=$(cat local_ip 2> /dev/null | grep lighthouse | sed 's/lighthouse[[:space:]]*//')