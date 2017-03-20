
echo "Compile and transaction test Ethereum"

echo "Type Filename [ENTER]:"
read fileInput

solc --optimize --combined-json bin $fileInput | jq -r '.'



