# quick tool to get data from local variables. using testRPC

echo "enter contract address:"

#CONTRACT_ADDRESS=0xfda4e0bdebd645814d615fcb1c2621bf0f45ab3f;
read CONTRACT_ADDRESS;

echo "choose function [example getTitle(), getContent()]"
read FUNCTION

#getTitle()

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n $FUNCTION | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)

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
