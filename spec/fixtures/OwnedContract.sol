pragma solidity ^0.4.2;

import "./owned.sol";

contract OwnedContract is owned {

    uint myVar;

    function OwnedContract() {
        myVar=10;
    }

    function getMyVar() onlyowner returns(uint var_value) {
        return myVar;
    }
}