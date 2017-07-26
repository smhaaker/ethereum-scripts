//*************************************
//Simple Eth Contract that gets and
//sets a string. 
//Purpose: For Testing Eth Scripts
//*************************************

pragma solidity ^0.4.9;

contract echo {

    //Global String
    string s;
    
    //Constructor function
    //Only called once - when deployed by the owner
    function echo(string initial) {
    	s = initial;
    }
    
    //String Setter
    function set_s(string input) {
    	s = input;
    }
    
    //String Getter
    function get_s() returns (string) {
    	return s;
    }
}
