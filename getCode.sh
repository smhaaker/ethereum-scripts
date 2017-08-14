#******************************************
#Tool to get data from local variables
#          -- using testRPC --
# Contract Address For Testing:
#0xfda4e0bdebd645814d615fcb1c2621bf0f45ab3f
#******************************************
echo "-------------------------------"
echo "Enter contract address: (0x...)"
#read in contract address
read CONTRACT_ADDRESS;

#User Function Selection
echo "Choose Desired Function [Example: getTitle(), getContent()]"
#Read in the desired function
read FUNCTION

#Get the hash of the desired function
HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n $FUNCTION | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
#Save the data of the hash
DATA="${HASH}"

#Output the data of the function
echo 'DATA:'
echo $DATA

echo '........'

#Call the contract and the user specified function
R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"latest"],"id":1}' | jq -r '.result')

#Output the corresponding result
echo 'Result:'
echo $R

echo '............'

#Decode the results
DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo 'Decoded String:'
echo $DECODE
