#*******************************************************************
#Script to test the implementation and execution of a smart contract
#			-- Using Testrpc --
#*******************************************************************
echo "---------------------------------------------------------"
echo "Test the Implementation and Execution of a Smart Contract"
echo "---------------------------------------------------------"
echo ""
#Prompt user for the filename or the filepath if the user has not moved to the directory
echo "Type the filename/filepath of the contract and then press [ENTER]: (example.sol)"
#Store the input
read fileInput

#Allow the user to select the account by number
echo 'Select account by number and then presss [ENTER]: '
#Store the input
read accountNumber

#Prompt user for their private key
echo "Enter the password of the account and then press [ENTER]"
#Read the password (Invisible)
read -s pwd

#********************************************
#Building a Constructor 
#********************************************
#Stores the test contract binhex
CONTRACT_BINHEX=$(solc --optimize --combined-json bin echo.sol | jq -r '.contracts."'$fileInput':echo".bin')

#Outputs Contract Binhex
echo "........"
echo $CONTRACT_BINHEX

#Stores a random string
STRING="String Test $((RANDOM))"
#Gets the length of that random string
STRING_LEN=$(printf "%064x\n" ${#STRING})
#Encode the string as hex
STRING_HEX=$(echo -n $STRING | xxd -p -c 32)
#Add extra zeroes for 32-byte chunks
STRING_FILL=$(( 64 - ${#STRING_HEX} ))
#Combine the string hex and padding
STRING_DATA=$(echo -n $STRING_HEX ; eval printf '0%.0s' {1..$STRING_FILL})
OFFSET=$(printf "%064x\n" 32)
#Append the offset, string length, and string data
DATA="${OFFSET}${STRING_LEN}${STRING_DATA}"

echo '.......'
#Output the final string
echo 'Data:'
echo $DATA

echo '.......'
CONTRACT_BINHEX=${CONTRACT_BINHEX}${DATA}
echo $DATA | fold -w64
echo '.......'

#Saves your ID
ID=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result['$accountNumber']')
#Unlocking the Account
curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"personal_unlockAccount","params":["'$ID'","'pwd'",0],"id":1}' | jq -r '.result'
#Getting the balance of the account
curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getBalance","params":["'$ID'","latest"],"id":1}' | jq -r '.result'
#Sending the transaction
TX=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"'$ID'","data":"0x'$CONTRACT_BINHEX'","gas":"0xF0000"}],"id":1}' | jq -r '.result')

echo  '.......'

#Outputting the transaction ID
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
#Outputting the Contract Address
echo 'Contract Address:' 
echo $CONTRACT_ADDRESS

echo '......'

HASH=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"web3_sha3","params":["0x'$(echo -n "get_s()" | xxd -p -c64)'"],"id":1}' | jq -r '.result' | cut -c3-10)
DATA="${HASH}"

echo 'DATA:'
echo $DATA

echo '........'


R=$(curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_call","params":[{"to":"'$CONTRACT_ADDRESS'","data":"0x'$DATA'"},"latest"],"id":1}' | jq -r '.result')
#Resulting String
echo 'Result:'
echo $R

echo '............'

DECODE=$(echo $R | sed 's/0x//' | fold -b64 | tail -1 | sed 's/00//g' | xxd -r -p)
echo 'Decoded String:'
echo $DECODE


echo '........'
#Origignal String
echo 'Original String:'
echo $STRING

echo '......'
echo 'If two statements above match we have set and get via smart contract'
