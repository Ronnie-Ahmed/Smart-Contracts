// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TeamWallet {
    uint256 transactionId = 1;

    error TransactionFailed();
    enum TransactionStatus {
        pending,
        debited,
        failed
    }

    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyDeployer() {
        require(msg.sender == owner, "Trnasaction Failed");
        _;
    }

    struct TransactionRecord {
        uint256 requestId;
        address requestedAddress;
        uint256 requestedAmount;
        uint256 approved;
        uint256 rejected;
        TransactionStatus status;
    }
    TransactionRecord[] private transactionRecord;
    mapping(uint256 => TransactionRecord) private mapToTransaction;
    mapping(uint256 => bool) private IdExist;

    mapping(address => bool) private isMember;
    address[] private memberArray;
    uint256 public credit;
    uint256 private approvedPercentage;
    uint256 private rejectPercentage;
    bool private isExecuted = false;
    mapping(address => mapping(uint256 => bool)) private didIApproved;
    mapping(address => mapping(uint256 => bool)) private didIRejected;

    function setWallet(
        address[] memory members,
        uint256 credtis
    ) public OnlyDeployer {
        require(members.length >= 1, "Transaction Failed");
        require(credtis > 0, "Transaction Failed");
        require(isExecuted == false, "Transaction Failed");
        for (uint256 i = 0; i < members.length; i++) {
            require(
                members[i] != owner,
                "Transaction Failed: Deployer cannot be a team member."
            );
            isMember[members[i]] = true;
            memberArray.push(members[i]);
        }
        isExecuted = true;
        credit = credtis;
        approvedPercentage = (members.length * 1000000 * 70) / (100);
        approvedPercentage = approvedPercentage / (1000000);
        rejectPercentage = (members.length * 1000000 * 31) / (100);
        rejectPercentage = rejectPercentage / (1000000);
    }

    //For spending amount from the wallet
    function spend(uint256 amount) public {
        require(isMember[msg.sender] == true, "Transaction Failed");
        require(amount > 0, "Transaction Failed");
        uint Id = transactionId;
        mapToTransaction[Id] = TransactionRecord(
            Id,
            msg.sender,
            amount,
            0,
            0,
            TransactionStatus.pending
        );
        didIApproved[msg.sender][Id] = true;
        mapToTransaction[Id].approved += 1;

        IdExist[Id] = true;
        if (
            memberArray.length < 2 &&
            mapToTransaction[Id].requestedAmount <= credit
        ) {
            mapToTransaction[Id].status = TransactionStatus.debited;
            credit = credit - mapToTransaction[Id].requestedAmount;
        } else if (mapToTransaction[Id].requestedAmount > credit) {
            mapToTransaction[Id].status = TransactionStatus.failed;
        }

        transactionId++;
    }

    //For approving a transaction request
    function approve(uint256 n) public {
        require(isMember[msg.sender] == true, "Transaction Failed");
        require(IdExist[n] == true, "Transaction Failed");
        require(didIApproved[msg.sender][n] == false, "Transaction Failed");
        require(
            mapToTransaction[n].requestedAmount <= credit,
            "Transaction Failed"
        );
        require(
            mapToTransaction[n].status == TransactionStatus.pending,
            "Transaction Failed"
        );

        didIApproved[msg.sender][n] = true;
        mapToTransaction[n].approved += 1;

        if (mapToTransaction[n].approved >= approvedPercentage) {
            mapToTransaction[n].status = TransactionStatus.debited;
            credit -= mapToTransaction[n].requestedAmount;
        }
    }

    //For rejecting a transaction request
    function reject(uint256 n) public {
        require(isMember[msg.sender] == true, "Transaction Failed");
        require(IdExist[n] == true, "Transaction Failed");
        require(didIApproved[msg.sender][n] == false, "Transaction Failed");
        require(
            mapToTransaction[n].requestedAmount <= credit,
            "Transaction Failed"
        );
        require(
            mapToTransaction[n].status == TransactionStatus.pending,
            "Transaction Failed"
        );
        didIApproved[msg.sender][n] = true;

        mapToTransaction[n].rejected += 1;
        if (mapToTransaction[n].rejected > rejectPercentage) {
            mapToTransaction[n].status = TransactionStatus.failed;
        }
    }

    //For checking remaing credits in the wallet
    function credits() public view returns (uint256) {
        require(isMember[msg.sender] == true, "Transaction Failed");
        return credit;
    }

    //For checking nth transaction status
    function viewTransaction(
        uint256 n
    ) public view returns (uint256 amount, string memory transactionStatus) {
        require(IdExist[n], "Transaction not found");
        require(isMember[msg.sender], "You are not a member");

        TransactionRecord memory transaction = mapToTransaction[n];
        return (
            transaction.requestedAmount,
            getStatusString(transaction.status)
        );
    }

    function getStatusString(
        TransactionStatus _status
    ) internal pure returns (string memory) {
        if (_status == TransactionStatus.pending) {
            return "pending";
        } else if (_status == TransactionStatus.debited) {
            return "debited";
        } else {
            return "failed";
        }
    }
}
