#script to list ethereum accounts

echo ''
echo 'Accounts:'

curl -sL 127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_accounts","params":[],"id":1}' | jq -r '.result'| cut -c3-46
