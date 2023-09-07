// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/*
 * @author: Ronnie Ahmed
 * @title: Got Talent Smart Contract
 * @dev: This smart contract is used to vote for the finalists of a talent show.
 * @github: https://github.com/Ronnie-Ahmed
 * Email : rksraisul@gmail.com
 */

contract DWGotTalent {
    address owner;
    error TransactionFailed();

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(owner == msg.sender, "Only Owner Can Call This Function");
        _;
    }

    bool isJudgeSelected = false;
    bool isSetVotingWeight = false;
    bool isFinalistSelected = false;
    bool isVotingStarted = false;
    bool isVotingEnded = false;

    address[] private judges;
    address[] private finalist;
    uint judgeVotingWeight;
    uint audienceVotingWeight;

    // Mapping to store the total votes for each finalist
    mapping(address => uint256) private gotTotalVote;

    // Mapping to track if an address is a judge
    mapping(address => bool) private isJudge;

    // Mapping to track the latest vote of each user
    mapping(address => address) private whomVoted;

    // Mapping to track if an address is a finalist
    mapping(address => bool) private isFinalist;

    // Array to store the winners
    address[] private winners;

    // Function to select judges
    function selectJudges(address[] memory arrayOfAddresses) public OnlyOwner {
        require(isVotingEnded == false, "Transaction Failed");
        require(isVotingStarted == false, "Transaction Failed");

        // Clear the isJudge mapping and judges array
        for (uint i = 0; i < judges.length; i++) {
            isJudge[judges[i]] = false;
        }
        delete judges;

        // Add new judges
        for (uint i = 0; i < arrayOfAddresses.length; i++) {
            if (
                arrayOfAddresses[i] == owner ||
                isFinalist[arrayOfAddresses[i]] == true
            ) {
                revert TransactionFailed();
            } else {
                judges.push(arrayOfAddresses[i]);
                isJudge[arrayOfAddresses[i]] = true;
            }
        }
        isJudgeSelected = true;
    }

    // Function to add voting weight for judges and audiences
    function inputWeightage(
        uint judgeWeightage,
        uint audienceWeightage
    ) public OnlyOwner {
        require(isVotingEnded == false, "Transaction Failed");
        require(isVotingStarted == false, "Transaction Failed");

        judgeVotingWeight = judgeWeightage;
        audienceVotingWeight = audienceWeightage;
        isSetVotingWeight = true;
    }

    // Function to select finalists
    function selectFinalists(
        address[] memory arrayOfAddresses
    ) public OnlyOwner {
        require(isVotingEnded == false, "Transaction Failed");
        require(isVotingStarted == false, "Transaction Failed");

        // Clear the isFinalist mapping and finalist array
        for (uint i = 0; i < finalist.length; i++) {
            isFinalist[finalist[i]] = false;
        }
        delete finalist;

        // Add new finalists
        for (uint i = 0; i < arrayOfAddresses.length; i++) {
            if (
                isJudge[arrayOfAddresses[i]] == true ||
                arrayOfAddresses[i] == owner
            ) {
                revert TransactionFailed();
            } else {
                finalist.push(arrayOfAddresses[i]);
                isFinalist[arrayOfAddresses[i]] = true;
            }
        }
        isFinalistSelected = true;
    }

    // Function to start the voting process
    function startVoting() public OnlyOwner {
        require(isVotingEnded == false, "Transaction Failed");

        require(
            isFinalistSelected == true &&
                isJudgeSelected == true &&
                isSetVotingWeight == true,
            "Transaction Failed"
        );
        isVotingStarted = true;
        isVotingEnded = false;
        isFinalistSelected = false;
        isJudgeSelected = false;
        isSetVotingWeight = false;
    }

    // Function to cast a vote
    function castVote(address finalistAddress) public {
        require(isVotingStarted == true, "Voting Hasn't Started");
        require(isVotingEnded == false, "Transaction Failed");

        if (isFinalist[finalistAddress] != true) {
            revert TransactionFailed();
        }

        address previous = whomVoted[msg.sender];
        if (previous != address(0) && previous != finalistAddress) {
            if (isJudge[msg.sender] == true) {
                gotTotalVote[previous] -= judgeVotingWeight;
            } else {
                gotTotalVote[previous] -= audienceVotingWeight;
            }
        }

        if (isJudge[msg.sender] == true) {
            gotTotalVote[finalistAddress] += judgeVotingWeight;
        } else {
            gotTotalVote[finalistAddress] += audienceVotingWeight;
        }
        whomVoted[msg.sender] = finalistAddress;
    }

    // Function to end the voting process and determine the winners
    function endVoting() public OnlyOwner {
        require(isVotingStarted == true, "Transaction Failed");
        require(isVotingEnded == false, "Transaction Failed");

        uint256 highestVotes = 0;

        for (uint i = 0; i < finalist.length; i++) {
            if (gotTotalVote[finalist[i]] > highestVotes) {
                highestVotes = gotTotalVote[finalist[i]];
            }
        }
        for (uint i = 0; i < finalist.length; i++) {
            if (gotTotalVote[finalist[i]] == highestVotes) {
                winners.push(finalist[i]);
            }
        }

        isVotingEnded = true;
        isVotingStarted = false;
    }

    // Function to show the winners
    function showResult() public view returns (address[] memory) {
        require(isVotingEnded == true, "Transaction Failed");
        if (winners.length == 0) {
            revert TransactionFailed();
        }
        return winners;
    }
}
