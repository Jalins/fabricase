#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
set -e

CAFILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer1.example.com/tls/ca.crt
CHANNEL_NAME=mychannel

function operate() {
	echo "=================start test offical cc=================="
	echo "============ peer channel create:peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/channel.tx --tls true --cafile $CAFILE"
	peer channel create -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/mychannel.tx --tls true --cafile $CAFILE
	echo "============ peer channel join -b mychannel.block"
	peer channel join -b mychannel.block
	sleep 2
	echo "============ peer channel update -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile $CAFILE"
	peer channel update -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile $CAFILE
	sleep 2

	echo "============ 切换到Org2MSP"
	CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
    CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
	CORE_PEER_ADDRESS=peer0.org2.example.com:8051
	CORE_PEER_LOCALMSPID=Org2MSP
	CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
	
	echo "============ peer channel join -b mychannel.block"
	peer channel join -b mychannel.block
	sleep 2
	echo "============ peer channel update -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org1MSPanchors.tx --tls --cafile $CAFILE"
	peer channel update -o orderer1.example.com:7050 -c $CHANNEL_NAME -f ./channel-artifacts/Org2MSPanchors.tx --tls --cafile $CAFILE
	
	sleep 2
	echo "============ 切换到Org1MSP"
	CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
    CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/server.key
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
	CORE_PEER_ADDRESS=peer0.org1.example.com:7051
	CORE_PEER_LOCALMSPID=Org1MSP
	CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
	echo "============ peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/"
	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/

	echo "============ peer chaincode instantiate -o orderer1.example.com:7050 --tls --cafile $CAFILE -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}'"
	peer chaincode instantiate -o orderer1.example.com:7050 --tls --cafile $CAFILE -C $CHANNEL_NAME -n mycc -v 1.0 -c '{"Args":["init","a", "100", "b","200"]}' -P "OR ('Org1MSP.peer','Org2MSP.peer')"
	sleep 5

	echo "============ peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'"
	peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'

	echo "============ peer chaincode invoke -o orderer1.example.com:7050 --tls true --cafile $CAFILE -C $CHANNEL_NAME -n mycc"
	peer chaincode invoke -o orderer1.example.com:7050 --tls true --cafile $CAFILE -C $CHANNEL_NAME -n mycc  -c '{"Args":["invoke","a","b","10"]}'
	sleep 5
	echo "============ peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'"
	peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'


	echo "============ 切换到Org2MSP"
	CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.crt
    CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/server.key
    CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
	CORE_PEER_ADDRESS=peer0.org2.example.com:8051
	CORE_PEER_LOCALMSPID=Org2MSP
	CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp

	echo "============ peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/"
	peer chaincode install -n mycc -v 1.0 -p github.com/chaincode/chaincode_example02/go/

	echo "============ peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'"
	peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'

	echo "============ peer chaincode invoke -o orderer1.example.com:7050 --tls true --cafile $CAFILE -C $CHANNEL_NAME -n mycc"
	peer chaincode invoke -o orderer1.example.com:7050 --tls true --cafile $CAFILE -C $CHANNEL_NAME -n mycc  -c '{"Args":["invoke","a","b","10"]}'
	sleep 5
	echo "============ peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'"
	peer chaincode query -C $CHANNEL_NAME -n mycc -c '{"Args":["query","a"]}'

	echo "=================test offical cc down=================="
}
operate
exit 0
