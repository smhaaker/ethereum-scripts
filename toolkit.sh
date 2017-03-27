# Remember to start RPC by either testrpc or geth --rpc otherwise this wont work

#!/bin/bash
COUNTER=-99

# Color constants
NC='\033[0m' # No Color
RED='\033[1;31m'
WHITE='\033[1;37m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'

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


function getBalance (){
    echo 'Enter accountID:'
    read accountID
    echo 'Balance for account:'
    curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$accountID'", "latest"],"id":1}'| jq -r '.result' 
    # update for account select... Need user input account number which equals hash account[0]= some hash
    
     }    


# displays current peers
function getPeers (){
    echo 'Current Peers:'
    curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"net_peerCount","params":[],"id":74}' | jq -r '.'

}

# get block by nr.
function getBlockByNr (){
    echo 'Enter block nr'
    read BLOCKNR
    echo 'Block By Nr:'
    curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getBlockByNumber","params":["'$BLOCKNR'", true],"id":1}' | jq -r '.'
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
    echo ' 5: Get Balance'
    echo ' 6: Get Peers'
    echo ' 7: Get Block By Nr'
    echo ' 0: quit'

    echo ''
    whiteLine

    read COUNTER
    
    case $COUNTER in
	[1]) getAccounts ;;
	[2]) currentBlock ;;
	[3]) getTransInfo ;;
        [4]) clientVersion ;;
        [5]) getBalance ;;
	[6]) getPeers ;;
	[7]) getBlockByNr ;;
	
	[9]) echo "may be ok" ;;
	[0]) echo "quitting" ;;
        *) echo "INVALID ENTRY" ;;	
    esac; 
    
done


