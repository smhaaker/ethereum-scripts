
pragma solidity ^0.4.9;

contract echo {
    string s;

    function echo(string d_s) {
            s = d_s;
	        }

    function set_s(string new_s) {
            s = new_s;
	        }

    function get_s() returns (string) {
            return s;
	        }
}