### single sender case

#!/bin/bash
source ./env.sh

rm -rf $UNSIGNED_TX_ROOT_DIR
rm -rf $SIGNED_TX_ROOT_DIR
rm -rf $ENCODED_TX_ROOT_DIR

echo "remove directories..."

mkdir -p $UNSIGNED_TX_ROOT_DIR
mkdir -p $SIGNED_TX_ROOT_DIR
mkdir -p $ENCODED_TX_ROOT_DIR

echo "create directories..."

# i=$1
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    for ((j=0;j<$ACCOUNT_COUNT_PER_LOOP;j++))
    do            
        NUMBER=$(($((i*$ACCOUNT_COUNT_PER_LOOP))+j))
        # NUMBER=$j
        # ACCOUNT_NUMBER=$(($NUMBER+29+28))
        ACCOUNT_NUMBER=$(($NUMBER+4)) #account number는 0부터 시작, 미리 validator 4대를 만들었기 때문에 +4 해줌
        ACCOUNT_NAME=$ACCOUNT_NAME_PREFIX$NUMBER
        echo "$BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend test"
        #ACCOUNT_ADDRESS=$($BINARY keys show $ACCOUNT_NAME -a --home $CURRENT_DATA_DIR --keyring-backend test)
        ACCOUNT_ADDRESS="inj1g753cq4thdqgtk6y93xhk9nzht0p8xu4kxqkyr"
        echo $ACCOUNT_ADDRESS

        # echo "
        # $BINARY tx bank send $ACCOUNT_ADDRESS $ACCOUNT_ADDRESS $SEND_AMOUNT$UNIT --chain-id $CHAIN_ID --home $CURRENT_DATA_DIR --keyring-backend test --generate-only > $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER"

        $BINARY tx bank send $ACCOUNT_ADDRESS $ACCOUNT_ADDRESS $SEND_AMOUNT$UNIT --chain-id $CHAIN_ID --home injective-cosmbench_nodes/node1 --keyring-backend test --generate-only > $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER


        echo "$BINARY tx sign $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER --chain-id $CHAIN_ID --from account_7 --home injective-cosmbench_nodes/node1 --offline --sequence $NUMBER --account-number 11 --keyring-backend test > $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$NUMBER"

        $BINARY tx sign $UNSIGNED_TX_ROOT_DIR/$UNSIGNED_TX_PREFIX$NUMBER --chain-id $CHAIN_ID --from account_7 --home injective-cosmbench_nodes/node1 --offline --sequence $NUMBER --account-number 11 --keyring-backend test > $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$NUMBER

        
        
        ENCODED=`$BINARY tx encode $SIGNED_TX_ROOT_DIR/$SIGNED_TX_PREFIX$NUMBER`

        # echo $ENCODED
        echo $ENCODED > $ENCODED_TX_ROOT_DIR/$ENCODED_TX_PREFIX$NUMBER

        # echo "Send tx"
        # ENCODED_TX=`cat $ENCODED_TX_ROOT_DIR/$ENCODED_TX_PREFIX$NUMBER`
        # curl -X POST -H "Content-Type: application/json" -d'{"tx_bytes":"'$ENCODED_TX'","mode":"BROADCAST_MODE_SYNC"}' "${api_url}/cosmos/tx/v1beta1/txs"
    done
done


echo "[ SHOW NODE ID ]"
for ((i=0;i<$NODE_COUNT;i++))
do
    CURRENT_DATA_DIR=$NODE_ROOT_DIR/node$i
    $BINARY tendermint show-node-id --home $CURRENT_DATA_DIR
done


echo "### 5_generate_signed_transactions.sh done"