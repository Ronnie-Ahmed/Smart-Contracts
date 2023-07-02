// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    string public name;
    uint256 numberofdelegatecandidate;
    address owner;

    constructor() {
        owner = msg.sender;
    }

    uint256 listingPrice = 0.01 ether;
    uint256 Id = 1;
    struct Voters {
        address voteraddress;
        string name;
        uint256 id;
        uint256 numberofVotes;
        bool isVoted;
        bool isVoter;
    }
    mapping(address => Voters) public voters;

    function addVoters(
        string memory _name,
        address payable _voteraddress
    ) external payable {
        require(msg.sender == owner, "Only Owner can call this function");
        require(voters[_voteraddress].isVoter != true, "Already Registered");
        voters[_voteraddress] = Voters(
            _voteraddress,
            _name,
            Id,
            3,
            false,
            true
        );
        Id++;
    }

    struct Election {
        string electionName;
        uint256 numberOfCandidate;
        bool isListed;
    }
    mapping(string => Election) private election;

    function createElection(
        string memory _name,
        uint256 _numberOfCandidate
    ) external {
        require(msg.sender == owner, "Only Owner can call this function");
        name = _name;
        require(election[_name].isListed == false, "Already Listed ");
        election[_name] = Election(_name, _numberOfCandidate, true);
    }

    struct Delegate {
        string delegatename;
        address delegationAddress;
        uint256 votecount;
        bool IsDelegated;
    }
    uint256 delegateCount;
    mapping(address => Delegate) public delegate;
    Delegate[] private delegateArray;

    function addDelegation(
        string memory _delegatename,
        address payable _delegationAddress
    ) external payable {
        require(msg.value == listingPrice, "Not the right amount send");
        require(
            delegateCount < election[name].numberOfCandidate,
            "Election candidate is full"
        );
        require(voters[_delegationAddress].isVoter == true, "Be a Voter First");
        delegate[_delegationAddress] = Delegate(
            _delegatename,
            _delegationAddress,
            0,
            true
        );
        delegateArray.push(
            Delegate(_delegatename, _delegationAddress, 0, true)
        );
        delegateCount++;
        (bool success, ) = _delegationAddress.call{value: msg.value}("");
        require(success, "Transaction failed");
    }

    function changeVoterInfo(
        string memory _name,
        address _voterAddress
    ) external {
        require(voters[_voterAddress].isVoter == true, "Not a voter");
        Voters storage newvoter = voters[_voterAddress];
        newvoter.name = _name;
    }

    function Vote(address from, address to) external {
        require(voters[from].isVoted != true, "Already finished voted");
        require(voters[from].numberofVotes != 0, "Already finished voted");
        require(delegate[to].IsDelegated == true, "Not a delegation Member");
        Voters storage changeVoter = voters[from];
        changeVoter.numberofVotes--;

        if (changeVoter.numberofVotes == 0) {
            changeVoter.isVoted = true;
        }
        Delegate storage changeDelegate = delegate[to];
        changeDelegate.votecount++;
    }

    function getResult() external view returns (Delegate memory) {
        require(delegateArray.length > 0, "No delegate in the election");
        Delegate memory Winner = delegateArray[0];
        for (uint i = 1; i < delegateArray.length; i++) {
            if (delegateArray[i].votecount > Winner.votecount) {
                Winner = delegateArray[i];
            }
        }

        return Winner;
    }

    function resetAllData() private {
        require(msg.sender == owner, "ONly owner can call this function");
        Id = 1;
        name = "";
        numberofdelegatecandidate = 0;
        delegateCount = 0;
    }
}
