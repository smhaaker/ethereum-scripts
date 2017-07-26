#*******************************************************************
#This script is used to load an Ethereum Smart Contract
#Simply cd to the area where your .sol file is and execute the script
#********************************************************************

echo "Compile and Execute Ethereum Contract"

echo "Type Filename [ENTER]: (Example.sol) "
read fileInput

#Solc is the solidity compiler
solc --optimize --combined-json bin $fileInput | jq -r '.'



