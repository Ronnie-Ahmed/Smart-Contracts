// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * @author: Ronnie Ahmed
 * @title: Team Wallet Smart Contract Hard
 * @github: https://github.com/Ronnie-Ahmed
 * Email : rksraisul@gmail.com
 */

contract TeamWallet {
    uint256 transactionId = 1; // Initialize transaction ID.
    error TransactionFailed(); // Define a custom error for transaction failures.

    enum TransactionStatus {
        pending,
        debited,
        failed
    }

    address owner; // Address of the contract owner.

    constructor() {
        owner = msg.sender; // Set the contract deployer as the owner.
    }

    modifier OnlyDeployer() {
        require(
            msg.sender == owner,
            "Transaction Failed: Only the deployer can call this function"
        );
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

    TransactionRecord[] private transactionRecord; // Array to store transaction records.
    mapping(uint256 => TransactionRecord) private mapToTransaction; // Mapping from ID to transaction record.
    mapping(uint256 => bool) private IdExist; // Mapping to check if a transaction ID exists.

    mapping(address => bool) private isMember; // Mapping to check if an address is a team member.
    address[] private memberArray; // Array to store team members' addresses.
    uint256 public credit; // Available wallet credit.
    uint256 private approvedPercentage; // Percentage of approvals required for a transaction.
    uint256 private rejectPercentage; // Percentage of rejections required for a transaction.
    bool private isExecuted = false; // Flag to ensure the wallet setup is executed only once.
    mapping(address => mapping(uint256 => bool)) private didIApproved; // Mapping to check if an address approved a transaction.
    mapping(address => mapping(uint256 => bool)) private didIRejected; // Mapping to check if an address rejected a transaction.
    uint256 public pending = 0; // Counter for pending transactions.
    uint256 public debitedCount2 = 0; // Counter for debited transactions.
    uint256 public failed = 0; // Counter for failed transactions.

    function setWallet(
        address[] memory members,
        uint256 credits
    ) public OnlyDeployer {
        require(
            members.length >= 1,
            "Transaction Failed: At least one member required"
        );
        require(
            credits > 0,
            "Transaction Failed: Credits must be greater than zero"
        );
        require(
            !isExecuted,
            "Transaction Failed: Wallet setup already executed"
        );

        for (uint256 i = 0; i < members.length; i++) {
            require(
                members[i] != owner,
                "Transaction Failed: Deployer cannot be a team member."
            );
            isMember[members[i]] = true;
            memberArray.push(members[i]);
        }

        isExecuted = true;
        credit = credits;
        approvedPercentage = (members.length * 1000000 * 70) / 100;
        approvedPercentage = approvedPercentage / 1000000;
        rejectPercentage = (members.length * 1000000 * 31) / 100;
        rejectPercentage = rejectPercentage / 1000000;
    }

    // For spending amount from the wallet
    function spend(uint256 amount) public {
        require(
            isMember[msg.sender],
            "Transaction Failed: Only team members can spend"
        );
        require(
            amount > 0,
            "Transaction Failed: Amount must be greater than zero"
        );

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
        pending += 1;
        IdExist[Id] = true;

        if (
            memberArray.length < 2 &&
            mapToTransaction[Id].requestedAmount <= credit
        ) {
            mapToTransaction[Id].status = TransactionStatus.debited;
            credit -= mapToTransaction[Id].requestedAmount;
            pending -= 1;
            debitedCount2 += 1;
        } else if (mapToTransaction[Id].requestedAmount > credit) {
            mapToTransaction[Id].status = TransactionStatus.failed;
            failed += 1;
            pending -= 1;
        }

        transactionId++;
    }

    // For approving a transaction request
    function approve(uint256 n) public {
        require(
            isMember[msg.sender],
            "Transaction Failed: Only team members can approve"
        );
        require(
            IdExist[n],
            "Transaction Failed: Transaction ID does not exist"
        );
        require(
            !didIApproved[msg.sender][n],
            "Transaction Failed: Already approved"
        );
        require(
            mapToTransaction[n].requestedAmount <= credit,
            "Transaction Failed: Insufficient credit"
        );
        require(
            mapToTransaction[n].status == TransactionStatus.pending,
            "Transaction Failed: Transaction is not pending"
        );

        didIApproved[msg.sender][n] = true;
        mapToTransaction[n].approved += 1;

        if (mapToTransaction[n].approved > approvedPercentage) {
            mapToTransaction[n].status = TransactionStatus.debited;
            credit -= mapToTransaction[n].requestedAmount;
            pending -= 1;
            debitedCount2 += 1;
        }
    }

    // For rejecting a transaction request
    function reject(uint256 n) public {
        require(
            isMember[msg.sender],
            "Transaction Failed: Only team members can reject"
        );
        require(
            IdExist[n],
            "Transaction Failed: Transaction ID does not exist"
        );
        require(
            !didIApproved[msg.sender][n],
            "Transaction Failed: Already approved"
        );
        require(
            mapToTransaction[n].requestedAmount <= credit,
            "Transaction Failed: Insufficient credit"
        );
        require(
            mapToTransaction[n].status == TransactionStatus.pending,
            "Transaction Failed: Transaction is not pending"
        );

        didIApproved[msg.sender][n] = true;

        mapToTransaction[n].rejected += 1;
        failed += 1;
        pending -= 1;
        if (mapToTransaction[n].rejected > rejectPercentage) {
            mapToTransaction[n].status = TransactionStatus.failed;
        }
    }

    // For checking remaining credits in the wallet
    function credits() public view returns (uint256) {
        require(
            isMember[msg.sender],
            "Transaction Failed: Only team members can check credits"
        );
        return credit;
    }

    // For checking nth transaction status
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

    function transactionStats()
        public
        view
        returns (uint debitedCount, uint pendingCount, uint failedCount)
    {
        require(isMember[msg.sender], "You are not a member");

        return (debitedCount2, pending, failed);
    }
}
