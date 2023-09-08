// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ScholarshipCreditContract {
    address owner;

    mapping(address => uint256) public myTotalCredit;
    mapping(address => bool) public isMarchent;
    mapping(address => bool) public isStudent;

    constructor() {
        owner = msg.sender;
        myTotalCredit[owner] += 1000000;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner Can call This Function");
        _;
    }

    //This function assigns credits to student getting the scholarship
    function grantScholarship(
        address studentAddress,
        uint credits
    ) public OnlyOwner {
        require(myTotalCredit[owner] >= credits, "Transaction Failed");
        require(studentAddress != address(0), "Transaction Failed");
        require(credits > 0, "Transaction Failed");
        require(studentAddress != owner, "Transaction failed");
        require(isMarchent[studentAddress] != true, "Transaction Failed");

        isStudent[studentAddress] = true;
        myTotalCredit[studentAddress] += credits;
        myTotalCredit[owner] -= credits;
    }

    //This function is used to register a new merchant who can receive credits from students
    function registerMerchantAddress(address merchantAddress) public OnlyOwner {
        require(merchantAddress != address(0), "Transaction Failed");
        require(merchantAddress != owner, "Transaction failed");
        require(isMarchent[merchantAddress] != true, "Transaction Failed");
        require(isStudent[merchantAddress] != true, "Transaction Failed");
        isMarchent[merchantAddress] = true;
    }

    //This function is used to deregister an existing merchant
    function deregisterMerchantAddress(
        address merchantAddress
    ) public OnlyOwner {
        require(merchantAddress != address(0), "Transaction Failed");
        require(merchantAddress != owner, "Transaction failed");
        require(isMarchent[merchantAddress] == true, "Transaction Failed");
        require(isStudent[merchantAddress] != true, "Transaction Failed");

        uint256 myRemaining = myTotalCredit[merchantAddress];
        myTotalCredit[merchantAddress] -= myRemaining;
        myTotalCredit[owner] += myRemaining;
        isMarchent[merchantAddress] = false;
    }

    //This function is used to revoke the scholarship of a student
    function revokeScholarship(address studentAddress) public OnlyOwner {
        require(isStudent[studentAddress] == true, "Transaction Failed");
        require(studentAddress != owner, "Transaction failed");
        uint256 myRemaining = myTotalCredit[studentAddress];
        myTotalCredit[owner] += myRemaining;
        myTotalCredit[studentAddress] -= myRemaining;
        isStudent[studentAddress] = false;
    }

    //Students can use this function to transfer credits only to registered merchants
    function spend(address merchantAddress, uint amount) public {
        require(merchantAddress != address(0), "Transaction Failed");
        require(amount > 0, "Transaction failed");
        require(isStudent[msg.sender] == true, "Transaction Failed");
        require(isMarchent[merchantAddress] == true, "Transaction Failed");
        myTotalCredit[merchantAddress] += amount;
        myTotalCredit[msg.sender] -= amount;
    }

    //This function is used to see the available credits assigned.
    function checkBalance() public view returns (uint) {
        require(
            isMarchent[msg.sender] == true ||
                isStudent[msg.sender] == true ||
                msg.sender == owner,
            "Transaction Failed"
        );
        return myTotalCredit[msg.sender];
    }
}
