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
        isApplied[msg.sender] = true;
        approve[msg.sender] = 1;
    }

    // Mapping to track membership status
    mapping(address => bool) private isAmember;
    mapping(address => uint256) private approveCount;

    // Mapping to track voting status for membership approval
    mapping(address => mapping(address => bool)) private didIVote;

    // Mapping to track voting status for member removal
    mapping(address => mapping(address => bool)) private didIVoteOnremove;
    mapping(address => uint256) private disApproveCount;
    mapping(address => uint256) private removeMemberCount;

    // Mapping to track membership application status
    mapping(address => bool) private isApplied;
    mapping(address => uint256) appliedCount;
    mapping(address => uint256) approve;

    // To apply for membership of DAO
    function applyForEntry() public {
        require(dao.length > 0);
        require(
            !isAmember[msg.sender],
            "Only Non-members can call this function"
        );
        require(!isApplied[msg.sender]);

        // Set membership application status
        isAmember[msg.sender] = false;
        isApplied[msg.sender] = true;
        approve[msg.sender] = 1;
    }

    // To approve the applicant for membership of DAO
    function approveEntry(address _applicant) public {
        require(dao.length > 0);
        require(!isAmember[_applicant]);
        require(approve[_applicant] == 1);
        require(isApplied[_applicant] == true);
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

    // Function to disapprove the applicant for membership
    function disapproveEntry(address _applicant) public {
        require(dao.length > 0);
        require(!didIVote[msg.sender][_applicant], "Already Voted");
        require(isAmember[msg.sender] == true, "Transaction Failed");

        // Calculate disapproval threshold based on 70%
        uint256 totalMember = dao.length;
        uint256 disapprovalRate = (70 * 1000) / 100;
        uint disapprovedneeded = (totalMember * disapprovalRate) / 100;

        // Update disapproval count and mark as voted
        disApproveCount[_applicant] += 1;
        didIVote[msg.sender][_applicant] = true;

        // Check if disapproval threshold is met
        uint256 marginCount = disApproveCount[_applicant] * 10;
        if (marginCount >= disapprovedneeded) {
            // Remove the applicant's membership status
            isAmember[_applicant] = false;
            approve[_applicant] = 0;
        }
    }

    // Function to remove a member from DAO
    function removeMember(address _memberToRemove) public {
        require(dao.length > 0);
        require(msg.sender != _memberToRemove);
        require(isAmember[msg.sender] == true, "Transaction Failed");
        require(isAmember[_memberToRemove] == true, "Transaction Failed");
        require(
            !didIVoteOnremove[msg.sender][_memberToRemove],
            "Already Voted"
        );

        // Calculate removal threshold based on 70%
        uint256 totalMember = dao.length - 1; // Exclude the owner
        uint256 removeRate = (70 * 1000) / 100;
        uint approvedneeded = (totalMember * removeRate) / 100;

        // Update removal count and mark as voted
        removeMemberCount[_memberToRemove] += 1;
        didIVoteOnremove[msg.sender][_memberToRemove] = true;

        // Check if removal threshold is met
        uint256 marginCount = removeMemberCount[_memberToRemove] * 10;
        if (marginCount >= approvedneeded) {
            // Remove the member from the DAO
            isAmember[_memberToRemove] = false;
            approve[_memberToRemove] = 0;

            // Shift elements to the left to fill the gap
            for (uint256 i = 0; i < dao.length; i++) {
                if (dao[i] == _memberToRemove) {
                    for (uint j = i; j < dao.length - 1; j++) {
                        dao[j] = dao[j + 1];
                    }
                    // Reduce the length of the array
                    dao.pop();
                }
            }
        }
    }

    // Function to allow a member to leave DAO
    function leave() public {
        require(dao.length > 0);
        require(isAmember[msg.sender] == true, "Transaction Failed");

        // Set membership status and approval count to 0
        isAmember[msg.sender] = false;
        approve[msg.sender] = 0;

        // Remove the member from the DAO
        for (uint256 i = 0; i < dao.length; i++) {
            if (dao[i] == msg.sender) {
                // Shift elements to the left to fill the gap
                for (uint j = i; j < dao.length - 1; j++) {
                    dao[j] = dao[j + 1];
                }
                // Reduce the length of the array
                dao.pop();
            }
        }
    }

    // Function to check membership status of a user
    function isMember(address _user) public view returns (bool) {
        require(dao.length > 0);
        require(isAmember[msg.sender] == true, "Transaction Failed");
        return isAmember[_user];
    }

    // Function to check the total number of members in the DAO
    function totalMembers() public view returns (uint256) {
        require(dao.length > 0);
        require(isAmember[msg.sender], "Transaction Failed");
        return dao.length;
    }
}
