#!/bin/bash
COUNTER=-99

#    .---------- constant part!
#    vvvv vvvv-- the code from above
NC='\033[0m' # No Color
RED='\033[1;31m'
WHITE='\033[1;37m'
CYAN='\033[0;36m'

GREEN='\033[0;32m'
GREEN='\033[1;37m'
GREEN='\033[1;37m'
GREEN='\033[1;37m'

# Get accounts function

function getAccounts (){
    echo 'Accounts:'
    curl -sL 127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result'| cut -c3-46 
}


# Get transaction receipt function
function getTransInfo(){
    echo 'Enter Transaction Number'
    read transNumber

    curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$transNumber'"],"id":1}' | jq -r '.result'
}


# get current block function
function currentBlock(){
    echo 'Current Block:'
    curl -sl 127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' | jq -r '.result'
}

# returns client information
function clientVersion(){
curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_clientVersion","params":[],"id":67}' | jq -r '.'
}

function whiteLine(){
    echo -e "${WHITE}===============================================${NC}"
}


clear

# main loop
while [  $COUNTER  -ne 0 ]; do

    whiteLine
    echo ''
    echo -e ' \t ' "${RED}Ethereum Toolkit Helper${NC}"
    echo '    Select Your Option [number + ENTER]:'
    echo ' 1: Get Current Accounts'
    echo ' 2: Get Current Block'
    echo ' 3: Get Transaction Receipt'
    echo ' 4: Get Client Info'
    echo ' 5: '
    echo ' 0: quit'

    echo ''
    whiteLine

    read COUNTER
    
    case $COUNTER in
	[1]) getAccounts ;;
	[2]) currentBlock ;;
	[3]) getTransInfo ;;
        [4]) clientVersion ;;
        [5]) getTransInfo ;;
	
	[9]) echo "may be ok" ;;
	[0]) echo "quitting" ;;
        *) echo "INVALID ENTRY" ;;	
    esac; 
    
done


