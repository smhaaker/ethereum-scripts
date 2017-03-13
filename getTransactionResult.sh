# Request

echo 'Enter transaction number'
read transNumber

curl -sL http://127.0.0.1:8545 -X POST --data '{"jsonrpc":"2.0","method":"eth_getTransactionReceipt","params":["'$transNumber'"],"id":1}' | jq -r '.'
