pragma solidity ^0.4.2;

contract owned {
    address public owner;

    event OwnerChanged(
    address newOwner,
    address previousOwner
    );

    modifier onlyowner {
        if (msg.sender != owner){throw;} //Consumes all gas
        _;
    }

    function changeOwner(address newOwner) onlyowner {
        OwnerChanged(newOwner,owner);
        owner=newOwner;
    }

    function owned() {
        owner=msg.sender;
    }
}