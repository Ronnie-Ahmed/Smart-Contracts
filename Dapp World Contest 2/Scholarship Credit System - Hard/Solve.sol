// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
 * @author: Ronnie Ahmed
 * @tittle: Scholarship Credit System Hard
 * @github: https://github.com/Ronnie-Ahmed
 * Email : rksraisul@gmail.com
 */

contract ScholarshipCreditContract {
    error TransactionFailed();
    address owner;

    // Mapping to store total credits for each address
    mapping(address => uint256) private myTotalCredit;

    // Mapping to track whether an address is a merchant or not
    mapping(address => bool) private isMarchent;

    // Mapping to track whether an address is a student or not
    mapping(address => bool) private isStudent;

    constructor() {
        owner = msg.sender;

        // Initialize the owner with initial credits in the "all" category
        categoryWiseCredit[owner]["all"] += 1000000;
        myCategory[owner] = "all";
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner Can call This Function");
        _;
    }

    // List of credit categories
    string[] private creditCategory = ["meal", "academics", "sports", "all"];

    // Mapping to associate addresses with their credit categories
    mapping(address => string) private myCategory;

    // Mapping to track whether a student is allowed to spend in a category
    mapping(address => mapping(string => bool)) private studentToCategory;

    // Mapping to store category-wise credits for each address
    mapping(address => mapping(string => uint256)) private categoryWiseCredit;

    // This function assigns credits to a student getting a scholarship
    function grantScholarship(
        address studentAddress,
        uint credits,
        string memory category
    ) public OnlyOwner {
        // Check if there are enough credits in the "all" category
        require(
            categoryWiseCredit[owner]["all"] >= credits,
            "Transaction Failed"
        );
        require(studentAddress != address(0), "Transaction Failed");
        require(credits > 0, "Transaction Failed");
        require(studentAddress != owner, "Transaction failed");
        require(isMarchent[studentAddress] != true, "Transaction Failed");

        bool isMatched = false;
        for (uint256 i = 0; i < creditCategory.length; i++) {
            if (
                keccak256(abi.encodePacked(creditCategory[i])) ==
                keccak256(abi.encodePacked(category))
            ) {
                isMatched = true;
            }
        }

        // Check if the provided category is valid
        if (
            keccak256(abi.encodePacked(category)) ==
            keccak256(abi.encodePacked("all"))
        ) {
            isMatched = true;
        }

        if (isMatched == false) {
            revert TransactionFailed();
        }

        isStudent[studentAddress] = true;
        categoryWiseCredit[studentAddress][category] += credits;
        categoryWiseCredit[owner]["all"] -= credits;
        myCategory[studentAddress] = category;
        studentToCategory[studentAddress][category] = true;
    }

    // This function is used to register a new merchant who can receive credits from students
    function registerMerchantAddress(
        address merchantAddress,
        string memory category
    ) public OnlyOwner {
        require(merchantAddress != address(0), "Transaction Failed");
        require(merchantAddress != owner, "Transaction failed");
        require(isStudent[merchantAddress] != true, "Transaction Failed");

        // Check if the provided category is valid
        bool isMatched = false;
        for (uint256 i = 0; i < creditCategory.length; i++) {
            if (
                keccak256(abi.encodePacked(creditCategory[i])) ==
                keccak256(abi.encodePacked(category))
            ) {
                isMatched = true;
            }
        }

        if (isMatched == false) {
            revert TransactionFailed();
        }

        isMarchent[merchantAddress] = true;
        myCategory[merchantAddress] = category;
    }

    // This function is used to deregister an existing merchant
    function deregisterMerchantAddress(
        address merchantAddress
    ) public OnlyOwner {
        require(merchantAddress != address(0), "Transaction Failed");
        require(merchantAddress != owner, "Transaction failed");
        require(isMarchent[merchantAddress] == true, "Transaction Failed");
        require(isStudent[merchantAddress] != true, "Transaction Failed");

        // Transfer remaining credits from the merchant to the owner
        uint256 myRemaining = categoryWiseCredit[merchantAddress]["all"];
        categoryWiseCredit[merchantAddress]["all"] -= myRemaining;
        categoryWiseCredit[owner]["all"] += myRemaining;
        isMarchent[merchantAddress] = false;
    }

    // This function is used to revoke the scholarship of a student
    function revokeScholarship(address studentAddress) public OnlyOwner {
        require(isStudent[studentAddress] == true, "Transaction Failed");
        require(studentAddress != owner, "Transaction failed");

        // Transfer remaining credits from the student to the owner
        uint256 myRemaining = categoryWiseCredit[studentAddress][
            myCategory[studentAddress]
        ];
        categoryWiseCredit[studentAddress][
            myCategory[studentAddress]
        ] -= myRemaining;
        categoryWiseCredit[owner]["all"] += myRemaining;
        isStudent[studentAddress] = false;
    }

    // Students can use this function to transfer credits only to registered merchants
    function spend(address merchantAddress, uint amount) public {
        require(merchantAddress != address(0), "Transaction Failed");
        require(amount > 0, "Transaction failed");
        require(isStudent[msg.sender] == true, "Transaction Failed");
        require(isMarchent[merchantAddress] == true, "Transaction Failed");

        uint256 creditNeeded = 0;
        string memory merchantCategory = myCategory[merchantAddress];

        if (
            studentToCategory[msg.sender]["all"] == true &&
            studentToCategory[msg.sender][merchantCategory] == true
        ) {
            uint256 remainingCredit = categoryWiseCredit[msg.sender][
                merchantCategory
            ];

            if (remainingCredit >= amount) {
                categoryWiseCredit[msg.sender][merchantCategory] -= amount;
                categoryWiseCredit[merchantAddress]["all"] += amount;
            } else if (remainingCredit < amount) {
                categoryWiseCredit[msg.sender][
                    merchantCategory
                ] -= remainingCredit;
                categoryWiseCredit[merchantAddress]["all"] += remainingCredit;
                creditNeeded = amount - remainingCredit;
                categoryWiseCredit[msg.sender]["all"] -= creditNeeded;
                categoryWiseCredit[merchantAddress]["all"] += creditNeeded;
            } else {
                revert TransactionFailed();
            }
        } else if (
            studentToCategory[msg.sender]["all"] == true &&
            studentToCategory[msg.sender][merchantCategory] != true
        ) {
            if (categoryWiseCredit[msg.sender]["all"] < amount) {
                revert TransactionFailed();
            }

            categoryWiseCredit[msg.sender]["all"] -= amount;
            categoryWiseCredit[merchantAddress]["all"] += amount;
        } else if (
            studentToCategory[msg.sender][merchantCategory] == true &&
            studentToCategory[msg.sender]["all"] != true
        ) {
            if (categoryWiseCredit[msg.sender][merchantCategory] < amount) {
                revert TransactionFailed();
            }

            categoryWiseCredit[msg.sender][merchantCategory] -= amount;
            categoryWiseCredit[merchantAddress]["all"] += amount;
        } else {
            revert TransactionFailed();
        }
    }

    // This function is used to see the available credits assigned.
    function checkBalance(string memory category) public view returns (uint) {
        require(
            isMarchent[msg.sender] == true ||
                isStudent[msg.sender] == true ||
                msg.sender == owner,
            "Transaction Failed"
        );

        // Check if the provided category is valid
        bool isMatched = false;
        for (uint256 i = 0; i < creditCategory.length; i++) {
            if (
                keccak256(abi.encodePacked(creditCategory[i])) ==
                keccak256(abi.encodePacked(category))
            ) {
                isMatched = true;
            }
        }

        if (
            keccak256(abi.encodePacked(category)) ==
            keccak256(abi.encodePacked("all"))
        ) {
            isMatched = true;
        }

        if (isMatched == false) {
            revert TransactionFailed();
        }

        return categoryWiseCredit[msg.sender][category];
    }

    // This function is used to get the category of a merchant
    function showCategory() public view returns (string memory) {
        require(isMarchent[msg.sender] == true, "Transaction Failed");
        return myCategory[msg.sender];
    }
}
