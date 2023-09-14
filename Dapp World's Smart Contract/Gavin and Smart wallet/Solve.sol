// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SmartWallet {
    address owner;

    constructor() {
        owner = msg.sender;
        hasAccess[msg.sender] = true;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner can Call This Function");
        _;
    }
    mapping(address => bool) hasAccess;
    uint256 walletBalance = 0;

    //this function allows adding funds to wallet
    function addFunds(uint amount) public {
        require(amount > 0, "Amount can not be Negative");
        require(hasAccess[msg.sender], "You do not hold access");
        walletBalance += amount;
        if (walletBalance > 10000) {
            revert();
        }
    }

    //this function allows spending an amount to the account that has been granted access by Gavin
    function spendFunds(uint amount) public {
        require(amount > 0, "Amount can not be Negative");
        require(amount <= walletBalance, "Amount Can not Exceed this Limit");
        require(hasAccess[msg.sender], "You do not hold access");
        walletBalance -= amount;
    }

    //this function grants access to an account and can only be accessed by Gavin
    function addAccess(address x) public OnlyOwner {
        require(!hasAccess[x], "Already Has Access");
        hasAccess[x] = true;
    }

    //this function revokes access to an account and can only be accessed by Gavin
    function revokeAccess(address x) public OnlyOwner {
        require(hasAccess[x], "Already don't have Access");
        hasAccess[x] = false;
    }

    //this function returns the current balance of the wallet
    function viewBalance() public view returns (uint) {
        require(hasAccess[msg.sender], "Don not have any access");
        return walletBalance;
    }
}
