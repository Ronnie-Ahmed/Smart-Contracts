// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Lottery is Ownable, ERC20, ReentrancyGuard {
    // Error messages
    error NotEnoughMoneytoBuyTicket();
    error NotEnoughTicket();
    error NotInRightState();

    // Variables
    uint256 ticketentrynumber = 1;
    uint256 private constant ticketprice = 1 ether;
    uint256 private constant lotterytime = 250;
    uint256 prizeamount;
    
    // Enum to represent different states of the lottery
    enum State {
        Created,
        Lotterytime,
        LotteryDraw
    }

    // Structure to represent a ticket
    struct TicketStructure {
        address participants;
        uint256 ticketnumber;
    }

    // Arrays and mappings to store tickets and ticket-related data
    TicketStructure[] ticketbox;
    mapping(address => uint256) ticketamount;
    mapping(address => uint256[]) tickets;
    mapping(uint256 => address) tickettoholder;

    // Current state of the lottery
    State public state;

    // Start and end time of the lottery
    uint256 lotterystarttime;
    uint256 lotteryendtime;

    // Constructor
    constructor() ERC20("LotteryTime", "LT") {
        state = State.Created;
    }

    // Function to create a new lottery
    function createLottery() external onlyOwner nonReentrant {
        require(state == State.Created, "Not in the right state");
        state = State.Lotterytime;
        lotterystarttime = block.timestamp;
        lotteryendtime = lotterystarttime + lotterytime;
    }

    // Function to allow users to get lottery tickets in exchange for tokens (ETH in this case)
    function getTicketToken(uint256 amount) external payable nonReentrant {
        require(state == State.Lotterytime, "Not in the right state");

        // Calculate the price for the requested number of tickets
        uint256 price = amount * ticketprice;
        prizeamount += price;

        // Check if the lottery time has ended and update the state if needed
        if (block.timestamp >= lotteryendtime) {
            state = State.LotteryDraw;
        }

        // Require the user to send the correct amount of ETH
        require(price == msg.value, "Not enough money to buy ticket tokens");

        // Mint tokens to the user and update the ticket amount for the user
        _mint(msg.sender, amount);
        ticketamount[msg.sender] += amount;
    }

    // Function for users to get lottery tickets
    function getTicket(uint256 amount) external nonReentrant {
        require(state == State.Lotterytime, "Not in the right state");

        // Check if the lottery time has ended and update the state if needed
        if (block.timestamp >= lotteryendtime) {
            state = State.LotteryDraw;
        }

        // Check if the user has enough tokens to buy the requested number of tickets
        if (ticketamount[msg.sender] < amount) {
            revert NotEnoughTicket();
        }

        // Create an array to store ticket numbers for the user
        uint256[] memory ticketnumbers = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            // Store the ticket entry number in the array and update other data
            ticketbox.push(TicketStructure(msg.sender, ticketentrynumber));
            ticketnumbers[i] = ticketentrynumber;
            tickettoholder[ticketentrynumber] = msg.sender;
            ticketentrynumber++;
        }

        // Update the user's ticket data and token balance
        tickets[msg.sender] = ticketnumbers;
        ticketamount[msg.sender] -= amount;
    }

    // Function for users to get their purchased tickets
    function getMyTickets() public view returns (uint256[] memory) {
        require(state == State.Lotterytime, "Not in the right state");

        uint256 amount = tickets[msg.sender].length;
        uint256[] memory tempTicket = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            tempTicket[i] = tickets[msg.sender][i];
        }
        return tempTicket;
    }

    // Function for the owner to select a winner and distribute the prize
    function winner() external payable onlyOwner nonReentrant returns (uint256) {
        require(state == State.LotteryDraw, "Still have time to get lottery tickets");
        require(msg.value == prizeamount, "Send the right prize money");

        // Generate a random number using blockhash-based random number generator
        uint256 randomnumber = _getRandomNumber(ticketentrynumber);
        address winneraddress = tickettoholder[randomnumber];

        // Send the prize amount to the winner
        (bool success, ) = winneraddress.call{value: msg.value}("");
        require(success, "Transaction failed");

        // Reset lottery data for the next round
        prizeamount = 0;
        state = State.Created;
        ticketentrynumber = 1;
        return randomnumber;
    }

    // Function to generate a random number using blockhash
    function _getRandomNumber(uint256 limit) private view returns (uint256) {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        return blockValue % limit;
    }
}
