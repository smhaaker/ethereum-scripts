# Ethereum Scripts

###### Contributors: Haaker, Nguyen, Egan

## Preface
Make sure to run <b>testrpc</b> or a similar testing environment to use scripts

Some of these scripts require a smart contract (See Link Below) to execute

http://solidity.readthedocs.io/en/develop/introduction-to-smart-contracts.html

Toolkit.sh Combines most of theses scripts into one comprehensive file


<b>Note:</b> If using geth, most of these scripts will work with a few tweaks
<hr>

### Compile.sh

This script is used to load an Ethereum Smart Contract

<b>Note:</b> Ensure that you cd into the correct path where your file is located at
<hr>

### echoCompile.sh

Script to test the implementation and execution of a smart contract

<b>Note:</b> Requires Testrpc
<hr>

### getAccounts.sh

This script will list all eth accounts

<b>Note:</b> Requires Testrpc
<hr>

### getCode.sh

This script will get data from the specified contract functions

<b>Note:</b> Requires Deployed Contract
<hr>

### getTransactionResult.sh

This script displays the transaction result from a specified transaction number

<b>Note:</b> Requires Transaction Number
<hr>

### toolkit.sh

A Shell Based Comprehensive Toolkit for Basic Ethereum Interaction 

<b>Note:</b> Start RPC by either testrpc or geth --rpc
<hr>

### echo.sol

A Simple Getter and Setter Contract

<b>Purpose:</b> For Testing Eth Scripts
<hr>

<em>A Special Thank You To IBM For Their Help</em>
