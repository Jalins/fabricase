#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0

set -e
ININT_PATH=${PWD}
cd "$(dirname "$0")"
SDIR=${PWD}

if [ -d "crypto-config" ]; then
    rm -rf crypto-config
fi
if [ ! -f /usr/local/bin/cryptogen ]; then
	cp $SDIR/bin/cryptogen /usr/local/bin
    chmod +x /usr/local/bin/cryptogen
fi
cryptogen generate --config=./crypto-config.yaml

export FABRIC_CFG_PATH=$SDIR
CHANNEL_NAME=mychannel


# 判断路径是否存在
function mkdirPath() {
	if [ ! -d channel-artifacts ]; then
		mkdir channel-artifacts
	fi
}

echo "#############################################################################"
echo "############################## 生成创世块 ####################################"
echo "#############################################################################"
mkdirPath
if [ ! -f /usr/local/bin/configtxgen ]; then
	cp $SDIR/bin/configtxgen /usr/local/bin
    chmod +x /usr/local/bin/configtxgen
fi

rm -rf ./channel-artifacts/*
configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/orderer.genesis.block
# configtxgen -profile TwoOrgsOrdererGenesis -outputBlock ./channel-artifacts/orderer.genesis.block
configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/mychannel.tx -channelID $CHANNEL_NAME
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP

echo "################################  创世块生成 成功###############################"

# 恢复之前的路径
cd $ININT_PATH

exit 0
