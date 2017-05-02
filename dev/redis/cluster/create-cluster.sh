#!/bin/bash

# Settings
PORT=6999
NODES=6
REPLICAS=1
WORKINGSET=1000
KEYSPACE=10000
LOSTWRITES=0
NOTACKWRITES=0
READS=0
WRITES=0
FAILEDWRITES=0

CacheKey=()
CacheValue=()

# Computed vars
ENDPORT=$((PORT+NODES))

# Gen radom key
gen_key() {
    s=$(date +%S)
    rand=$(awk 'BEGIN{srand(); print rand()}')
    if [ "${rand}" > 0.5 ]
    then
        key="${s}key_$(awk -v min=1 -v max=${KEYSPACE} 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
    else
        key="${s}key_$(awk -v min=1 -v max=${WORKINGSET} 'BEGIN{srand(); print int(min+rand()*(max-min+1))}')"
    fi
    echo ${key}
}

check_consistency() {
    key=$1
    value=$2
    position=0
    index=0
    for i in "${CacheKey[@]}"
    do
        index=$((index+1))
        if [ "${i}" = "${key}" ]
        then
            position=${index}
        fi
    done

    expected=${CacheValue[${position}]}
    if [ "${expected}" != "" ]
    then
        if [ "${expected}" > "${value}" ]
        then
            LOSTWRITES=$((LOSTWRITES+expected-value))
        else
            NOTACKWRITES=$((NOTACKWRITES+value-expected))
        fi
    fi
 }

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

# Inc value in real port
inc_value_for_key() {
    key=$1
    value=$2
    port=$(get_real_port $key)
    result=$(redis-cli -p $port INCR $key)
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

# start one redis instance for cluster
if [ "$1" == "startOne" ]
then
    port=$2
    echo "Starting ${port}"
    docker stop myport${port}redis
    docker run --rm --net=host -p ${port}:${port} --name myport${port}redis -d my${port}redis
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

# Consistency test example
if [ "$1" == "test" ]
then
    while :
    do
        key=$(gen_key)
        CacheKey+=(${key})
        value=$(get_value_by_key ${key})

        if [ "$value" == "" ]
        then
            value=0
        fi

        check_consistency ${key} ${value}
        READS=$((READS+1))

        inc_value=$(inc_value_for_key ${key})

        if [ "$inc_value" == "" ]
        then
            FAILEDWRITES=$((FAILEDWRITES+1))
        else
            CacheValue+=(${inc_value})
            WRITES=$((WRITES+1))
        fi

        echo "${READS} R | ${WRITES} W (${FAILEDWRITES} err) | ${LOSTWRITES} lost | ${NOTACKWRITES} noack"
    done
    exit 0
fi

# Add a new node
if [ "$1" == "add" ]
then
    new_node=$2
    exist_node="127.0.0.1:$((PORT+1))"
    ./redis-trib.rb add-node ${new_node} ${exist_node}
    exit 0
fi

# Add a slave node
if [ "$1" == "slave" ]
then
    new_node=$2
    exist_node="127.0.0.1:$((PORT+1))"
    ./redis-trib.rb add-node --slave ${new_node} ${exist_node}
    exit 0
fi

# Delete a slave node
if [ "$1" == "delete" ]
then
    del_node=$2
    exist_node="127.0.0.1:$((PORT+1))"
    ./redis-trib.rb del-node ${exist_node} ${del_node}
    exit 0
fi
