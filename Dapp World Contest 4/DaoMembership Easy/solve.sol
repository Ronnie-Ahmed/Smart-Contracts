// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 

Author : Md Raisul Islam Ronnie
Email : rksraisul@gmail.com
Github :  https://github.com/Ronnie-Ahmed

*/

contract DAOMembership {
    address owner;

    address[] dao;

    constructor() {
        owner = msg.sender;

        // Initialize the owner as the first member of the DAO
        isAmember[msg.sender] = true;
        dao.push(msg.sender);
    }

    // Mapping to track membership status
    mapping(address => bool) private isAmember;

    // Mapping to track if a user has called the applyForEntry function
    mapping(address => bool) private didCall;

    // Mapping to track approval count for each applicant
    mapping(address => uint256) private approveCount;

    // Mapping to track voting status for membership approval
    mapping(address => mapping(address => bool)) public didIVote;

    // To apply for membership of DAO
    function applyForEntry() public {
        require(
            !isAmember[msg.sender],
            "Only Non-members can call this function"
        );
        require(!didCall[msg.sender], "Already called the function");

        // Mark the user as having called the function and set membership status to false
        didCall[msg.sender] = true;
        isAmember[msg.sender] = false;
    }

    // To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public {
        require(
            didCall[_applicant] == true && !isAmember[_applicant],
            "Transaction Failed"
        );
        require(!didIVote[msg.sender][_applicant], "Already Voted");
        require(isAmember[msg.sender] == true, "Transaction Failed");

        // Calculate approval threshold based on 30%
        uint256 totalMember = dao.length;
        uint256 approvalRate = (30 * 1000) / 100;
        uint approvedneeded = (totalMember * approvalRate) / 100;

        // Update approval count and mark as voted
        approveCount[_applicant] += 1;
        didIVote[msg.sender][_applicant] = true;

        // Check if approval threshold is met
        uint256 marginCount = approveCount[_applicant] * 10;
        if (marginCount >= approvedneeded) {
            // Add the applicant as a member
            dao.push(_applicant);
            isAmember[_applicant] = true;
        }
    }

    // Function to check membership status of a user
    function isMember(address _user) public view returns (bool) {
        require(isAmember[msg.sender] == true, "Transaction Failed");
        return isAmember[_user];
    }

    // Function to check the total number of members in the DAO
    function totalMembers() public view returns (uint256) {
        require(isAmember[msg.sender], "Transaction Failed");
        return dao.length;
    }
}
