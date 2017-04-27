#!/bin/bash

# Settings
PORT=6999
NODES=6
REPLICAS=1

# Computed vars
ENDPORT=$((PORT+NODES))

# Get real port
get_real_port() {
    name=$1
    PORT=$((PORT+1))
    real_port=$(redis-cli -p $PORT GET $name | awk '{split($3, a, ":"); print a[2]}')
    if [ "${real_port}" == "" ]
    then
      echo ${PORT}
    else
      echo ${real_port}
    fi
}

# Get value in real port
get_value_by_key() {
    key=$1
    port=$(get_real_port $key)
    value=$(redis-cli -p $port GET $key)
    echo ${value}
}

# Set value in real port
set_value_for_key() {
    key=$1
    value=$2
    port=$(get_real_port $key)
    result=$(redis-cli -p $port SET $key $value)
    echo ${result}
}

# Start redis instance for cluster
if [ "$1" == "start" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        echo "Starting $PORT"
        docker stop myport${PORT}redis
        docker run --rm --net=host -p ${PORT}:${PORT} --name myport${PORT}redis -d my${PORT}redis
    done
    exit 0
fi

# Create cluster use start redis instance
if [ "$1" == "create" ]
then
    HOSTS=""
    while [ $((PORT <ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        HOSTS="$HOSTS 127.0.0.1:$PORT"
    done
    ./redis-trib.rb create --replicas $REPLICAS $HOSTS
    exit 0
fi

# Stop cluster
if [ "$1" == "stop" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        echo "Stopping $PORT"
        redis-cli -p $PORT shutdown nosave
    done
    exit 0
fi

# Watch cluster
if [ "$1" == "watch" ]
then
    PORT=$((PORT+1))
    while [ 1 ]; do
        clear
        date
        redis-cli -p $PORT cluster nodes | head -30
        sleep 1
    done
    exit 0
fi

# Watch cluster tail logs
if [ "$1" == "tail" ]
then
    INSTANCE=$2
    PORT=$((PORT+INSTANCE))
    if [ $(($PORT < ENDPORT)) != "0" ]
    then
        docker logs -f myport${PORT}redis
    else
        echo "Cluster port is ${PORT} instance not exist"
    fi
    exit 0
fi

# Call redis command in redis cluster
if [ "$1" == "call" ]
then
    while [ $((PORT < ENDPORT)) != "0" ]; do
        PORT=$((PORT+1))
        redis-cli -p $PORT $2 $3 $4 $5 $6 $7 $8 $9
    done
    exit 0
fi

# Set value for key
if [ "$1" == "set" ]
then
    reslut=$(set_value_for_key $2 $3)
    echo "set $2 $3 ${result}"
    exit 0
fi

# Get value by key
if [ "$1" == "get" ]
then
    value=$(get_value_by_key $2)
    if [ "${value}" != "" ]
    then
      echo "value is ${value}"
    else
      echo "value not exist"
    fi
    exit 0
fi

# Echo 0 1000000000
if [ "$1" == "example" ]
then
    value=$(get_value_by_key __last__)
    if [ "${value}" == "" ]
    then
      value=0
    fi
    while [ $((value < 1000000000)) != 0 ]; do
      set_value_for_key "foo${value}" ${value}
      value=$((value+1))
      set_value_for_key __last__ ${value}
      echo "set foo${value} ${value}"
    done
    exit 0
fi

# Check cluster nodes status
if [ "$1" == "check" ]
then
    PORT=$((PORT+1))
    host="127.0.0.1:${PORT}"
    echo ${host}
    ./redis-trib.rb check ${host}
    exit 0
fi

# Reshard from source node to target node
if [ "$1" == "reshard" ]
then
    source_nodeid=$2
    target_nodeid=$3
    num=$4
    perform_host=$5
    perform_port=$6
    ./redis-trib.rb reshard --from ${source_nodeid} --to ${target_nodeid} --slots ${num} --yes ${perform_host}:${perform_port}
    exit 0
fi
