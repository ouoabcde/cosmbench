#!/bin/bash
source ./env.sh
source ./run_env.sh



if [ -d "$TESTDIR" ]; then
    echo "Removing $TESTDIR directory..."
    rm -rf $TESTDIR
fi

cp -rf $NODE_ROOT_DIR $TESTDIR

for ((i=1;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$TESTDIR/node$i
    cp -f $TESTDIR/node0/config/genesis.json $CURRENT_DATA_DIR/config/genesis.json 
done

for ((i=0;i<$NODE_COUNT;i++))
do
    INDEX=$i
    CURRENT_DATA_DIR=$TESTDIR/node$i


    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # "stake" -> "usei"로 변경
        sed -i '' 's/"stake"/"usei"/g' "$CURRENT_DATA_DIR/config/genesis.json"

        # Proxy App PORT 변경
        echo "sed -i '' "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # RPC PORT 변경
        echo "sed -i '' "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i '' "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # P2P PORT 변경
        echo "sed -i '' "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # [pprof port] 변경
        echo "sed -i '' "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # 중복 IP 허용
        echo "sed -i '' 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Mempool Size 변경
        echo "sed -i '' 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # cache size 변경 (Mempool size 변경에서 오는 변경 사항 폐기용)
        sed -i '' 's/cache-size = 600000/cache-size = 10000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Minimum Gas Prices 변경
        echo "sed -i '' 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC PORT 변경
        echo "sed -i '' "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC WEB PORT 변경
        echo "sed -i '' "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # TCP PORT 변경
        echo "sed -i '' "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml"

        # HTTP PORT 변경
        echo "sed -i '' "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # WEB SOCKET PORT 변경
        echo "sed -i '' "s#ws_port = 8546#ws_port = ${WEB_SOCKET_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i '' "s#ws_port = 8546#ws_port = ${WEB_SOCKET_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # Turn off prometheus
        echo "sed -i '' "s#prometheus = true#prometheus = false#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i '' "s#prometheus = true#prometheus = false#g" "$CURRENT_DATA_DIR/config/config.toml"
    else # Linux and others
        # "stake" -> "usei"로 변경
        sed -i 's/"stake"/"usei"/g' "$CURRENT_DATA_DIR/config/genesis.json"

        # Proxy App PORT 변경
        echo "sed -i "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s#proxy-app = \"tcp://127.0.0.1:26658\"#proxy-app = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${PROXYAPP_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # RPC PORT 변경
        echo "sed -i "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s#laddr = \"tcp://127.0.0.1:26657\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${RPC_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # P2P PORT 변경
        echo "sed -i "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i "s#laddr = \"tcp://0.0.0.0:26656\"#laddr = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${P2P_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # [pprof port] 변경
        echo "sed -i "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i "s#pprof-laddr = \"localhost:6060\"#pprof-laddr = \"${PRIVATE_HOSTS[$INDEX]}:${PPROF_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/config.toml"

        # 중복 IP 허용
        echo "sed -i 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/allow-duplicate-ip = false/allow-duplicate-ip = true/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Mempool Size 변경
        echo "sed -i 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml""
        sed -i 's/size = 1000/size = 60000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # cache size 변경 (Mempool size 변경에서 오는 변경 사항 폐기용)
        sed -i 's/cache-size = 600000/cache-size = 10000/g' "$CURRENT_DATA_DIR/config/config.toml"

        # Minimum Gas Prices 변경
        echo "sed -i 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml""
        sed -i 's/minimum-gas-prices = "0.02usei"/minimum-gas-prices = "0usei"/g' "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC PORT 변경
        echo "sed -i "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s/address = \"0.0.0.0:9090\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # gRPC WEB PORT 변경
        echo "sed -i "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s/address = \"0.0.0.0:9091\"/address = \"${PRIVATE_HOSTS[$INDEX]}:${GRPC_WEB_PORTS[$INDEX]}\"/g" "$CURRENT_DATA_DIR/config/app.toml"

        # TCP PORT 변경
        echo "sed -i "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#address = \"tcp://0.0.0.0:1317\"#address = \"tcp://${PRIVATE_HOSTS[$INDEX]}:${API_PORTS[$INDEX]}\"#g" "$CURRENT_DATA_DIR/config/app.toml"

        # HTTP PORT 변경
        echo "sed -i "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#http_port = 8545#http_port = ${HTTP_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # WEB SOCKET PORT 변경
        echo "sed -i "s#ws_port = 8546#ws_port = ${WEB_SOCKET_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml""
        sed -i "s#ws_port = 8546#ws_port = ${WEB_SOCKET_PORTS[$INDEX]}#g" "$CURRENT_DATA_DIR/config/app.toml"

        # Turn off prometheus
        echo "sed -i "s#prometheus = true#prometheus = false#g" "$CURRENT_DATA_DIR/config/config.toml""
        sed -i "s#prometheus = true#prometheus = false#g" "$CURRENT_DATA_DIR/config/config.toml"
    fi
done

# [persistent peers]
echo "Update persistent_peers"
PERSISTENT_PEERS=""
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    $BINARY tendermint show-node-id --home $CURRENT_DATA_DIR
done

for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    NODE_ID=$($BINARY tendermint show-node-id --home $CURRENT_DATA_DIR)
    PERSISTENT_PEERS=$PERSISTENT_PEERS${NODE_ID}'@'${PRIVATE_HOSTS[$i]}':'${P2P_PORTS[$i]}','
done
PERSISTENT_PEERS=${PERSISTENT_PEERS%,} #마지막에 ,를 제거하겠다는 의미

echo "PERSISTENT_PEERS : "$PERSISTENT_PEERS
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$TESTDIR/node$i

    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "sed -i '' "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i '' "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
    else # Linux and others
        echo "sed -i "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml"
        sed -i "s/persistent-peers = ".*"/persistent-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
    fi
done

# [persistent_peers] 설정
# echo "Updating persistent_peers..."
# PERSISTENT_PEERS=""
# for ((j = 0; j < $NODE_COUNT; j++)); do
#     PEER_ID=$($BINARY tendermint show-node-id --home "$TESTDIR/node$j")
#     if [ -n "$PEER_ID" ]; then
#         PERSISTENT_PEERS+="${PEER_ID}@${PRIVATE_HOSTS[$j]}:${P2P_PORTS[$j]},"
#     else
#         echo "Failed to retrieve PEER_ID for node${j}. Skipping..."
#     fi
# done

# # 마지막 , 제거
# PERSISTENT_PEERS=${PERSISTENT_PEERS%,}

# # persistent_peers 반영
# for ((i = 0; i < $NODE_COUNT; i++)); do
#     CURRENT_DATA_DIR="$TESTDIR/node$i"
#     sed -i '' "s/persistent-peers = \"\"/persistent-peers = \"$PERSISTENT_PEERS\"/g" "$CURRENT_DATA_DIR/config/config.toml"
# done

# # [persistent peers]
# echo "Update persistent_peers"
# PERSISTENT_PEERS=""

# for ((j = 0; j < $NODE_COUNT; j++)); do
#     # 각 노드의 PEER_ID를 동적으로 가져옴
#     PEER_ID=$($BINARY tendermint show-node-id --home "${TESTDIR}/node${j}")

#     # PEER_ID 확인 후 추가
#     if [ -n "$PEER_ID" ]; then
#         PERSISTENT_PEERS+="${PEER_ID}@${PRIVATE_HOSTS[$j]}:${P2P_PORTS[$j]},"
#     else
#         echo "Failed to retrieve PEER_ID for node${j}. Skipping..."
#     fi
# done

# echo "PERSISTENT_PEERS : "$PERSISTENT_PEERS
# for ((i = 0; i < $NODE_COUNT; i++))
# do
#     CURRENT_DATA_DIR=$TESTDIR/node$i
#     # echo "sed -i "s/persistent_peers = \"\"/persistent_peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml"
#     sed -i '' "s/persistent-peers = \"\"/persistent-peers = \"$PERSISTENT_PEERS\"/g" $CURRENT_DATA_DIR/config/config.toml
# done
