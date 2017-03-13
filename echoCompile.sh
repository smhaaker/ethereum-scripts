#Script for ethereum testing compile and submit contract 
#Altered to allowed custom contract input and account selection
#Using testrpc


echo "Compile and transaction test Ethereum"

echo "Type Filename [ENTER]:"
read fileInput

echo 'Select account [Number + ENTER]'
read accountNumber

echo "Enter Password [ENTER]"
read pwd

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

echo 'Data:'
echo $DATA

echo '.......'


CONTRACT_BINHEX=${CONTRACT_BINHEX}${DATA}

echo $DATA | fold -w64


echo '.......'


ID=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result['$accountNumber']')

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"personal_unlockAccount","params":["'$ID'","'pwd'",0],"id":1}' | jq -r '.result'

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$ID'","latest"],"id":1}' | jq -r '.result'

TX=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"'$ID'","data":"0x'$CONTRACT_BINHEX'","gas":"0xF0000"}],"id":1}' | jq -r '.result')

echo  '.......'


echo 'Transaction ID:'
echo $TX

echo '....'

while :
do
    CONTRACT_ADDRESS=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$TX'"],"id":1}' | jq -r '.result.contractAddress')
    if echo $CONTRACT_ADDRESS | grep '0x' >/dev/null 2>&1
    then
	break
    fi
done

echo 'Contract Address:' 
echo $CONTRACT_ADDRESS

echo '......'

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "get_s()" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
DATA="${HASH}"

echo 'DATA:'
echo $DATA

echo '........'


R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"latest"],"id":1}' | jq -r '.result')

echo 'Result:'
echo $R

echo '............'

DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo 'Decoded String:'
echo $DECODE


echo '........'

echo 'Original String:'
echo $STRING

echo '......'
echo 'If two statements above match we have set and get via smart contract'
