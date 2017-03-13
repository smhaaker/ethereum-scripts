#!/bin/bash
COUNTER=-99


# Get accounts function

function getAccounts (){
    echo 'Accounts:'
    curl -sL 127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result'| cut -c3-46
}


# Get transaction receipt function
function getTransInfo(){
    echo 'Enter Transaction Number'
    read transNumber

    curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$transNumber'"],"id":1}' | jq -r '.'
}


# get current block function
function currentBlock(){
    echo 'Current Block:'
    curl -sl 127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r '.result'
}

while [  $COUNTER  -ne 0 ]; do

    echo '====================================='
    echo ''
    
    echo 'Ethereum Toolkit Helper'
    echo 'select your option [number + ENTER]:'
    echo '1: Get Current Accounts'
    echo '2: Get Current Block'
    echo '3: Get Transaction Receipt'
    echo '0: quit'

    echo ''
    echo '====================================='
    
    read COUNTER
    
    case $COUNTER in
	[1]) getAccounts ;;
	[2]) currentBlock ;;
	[3]) getTransInfo ;;
	[9]) echo "may be ok" ;;
	[0]) echo "quitting" ;;
        *) echo "INVALID ENTRY" ;;	
    esac; 
    
done


