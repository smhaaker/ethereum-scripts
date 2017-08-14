#Script for ethereum testing
#Altered to allowe custom contract input and account selection

echo "Compile and transaction test Ethereum"

echo "type filename [ENTER]:"

read fileInput

CONTRACT_BINHEX=$(solc --optimize --combined-json bin echo.sol | jq -r '.contracts."'$fileInput':echo".bin')

echo "........"
echo $CONTRACT_BINHEX


STRING="String Test $((RANDOM))"
STRING_LEN=$(printf "%064x\n" ${#STRING})
STRING_HEX=$(echo -n $STRING | xxd -p -c 32)
STRING_FILL=$(( 64 - ${#STRING_HEX} ))
STRING_DATA=$(echo -n $STRING_HEX ; eval printf '0%.0s' {1..$STRING_FILL})
OFFSET=$(printf "%064x\n" 32)

DATA="${OFFSET}${STRING_LEN}${STRING_DATA}"

echo '.......'

echo $DATA

echo '.......'


CONTRACT_BINHEX=${CONTRACT_BINHEX}${DATA}

echo $DATA | fold -w64


echo '.......'

ID=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result[0]')

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"personal_unlockAccount","params":["'$ID'","'$Doolittle123'",0],"id":1}' | jq -r '.result'

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$ID'","latest"],"id":1}' | jq -r '.result'

TX=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"'$ID'","data":"0x'$CONTRACT_BINHEX'","gas":"0xF0000"}],"id":1}' | jq -r '.result')

echo "transaction ID: $TX"

echo '....'

while :
do
    CONTRACT_ADDRESS=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TX'"],"id":1}' | jq -r '.result.contractAddress')
    if echo $CONTRACT_ADDRESS | grep '0x' >/dev/null 2>&1
    then
	break
    fi
done
echo "contract address: $CONTRACT_ADDRESS"


echo '......'

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "get_s()" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
DATA="${HASH}"
echo $DATA


echo '........'

echo 'block number:'
curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TX'"],"id":1}' | jq -r '.result.blockNumber'

echo '....'

R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"latest"],"id":1}' | jq -r '.result')
echo $R

echo '............'

DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo $DECODE


echo '........'

echo $STRING

echo 'If two statements above match we have set and get via smart contract'


echo '....'

STRING="Hello, World"
STRING_LEN=$(printf "%064x\n" ${#STRING})
STRING_HEX=$(echo -n $STRING | xxd -p -c 32)
STRING_FILL=$(( 64 - ${#STRING_HEX} ))
STRING_DATA=$(echo -n $STRING_HEX ; eval printf '0%.0s' {1..$STRING_FILL})
OFFSET=$(printf "%064x\n" 32)
DATA="${OFFSET}${STRING_LEN}${STRING_DATA}"
echo $DATA


echo "...."

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "set_s(string)" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
echo "function hash: $HASH"

echo "....."

DATA=${HASH}${DATA}
echo $DATA

echo "..."


TX=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"'$ID'","to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"}],"gas:":"0xF0000","id":1}' | jq -r '.result')
echo "transaction ID: $TX"

while :
do
        R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TX'"],"id":1}' | jq -r '.result.blockNumber')
	if echo $R | grep '0x' >/dev/null 2>&1
	then
	    break
	fi
done

echo $R

echo '.......'

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "get_s()" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
DATA="${HASH}"
R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"latest"],"id":1}' | jq -r '.result')
DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo $DECODE

echo 'enter original tx number'
read TX

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TX'"],"id":1}' | jq -r '.result.blockNumber'

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "get_s()" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
DATA="${HASH}"
R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"0x34"],"id":1}' | jq -r '.result')
DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo $DECODE

