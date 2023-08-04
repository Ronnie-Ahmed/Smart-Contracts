// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Lottery is Ownable, ERC20 {
    error NotEnoughMoneytoBuyTicket();
    error NotEnoughTicket();
    error NotInRighState();
    uint256 ticketentrynumber = 1;

    uint256 private constant ticketprice = 1 ether;
    uint256 private constant lotterytime = 600;
    enum State {
        Created,
        Lotterytime,
        LOtteryDraw
    }
    struct TicketStructure {
        address participants;
        uint256 ticketnumber;
    }
    TicketStructure[] public ticketbox;
    mapping(address => uint256) public ticketamount;
    mapping(address => uint256[]) public tickets;
    State public state;
    uint256 lotterystarttime;
    uint256 lotteryendtime;

    constructor() ERC20("LotteryTime", "LT") {
        state = State.Created;
    }

    function createLottary() external onlyOwner {
        if (state != State.Lotterytime) {
            revert NotInRighState();
        }
        state = State.Lotterytime;
        lotterystarttime = block.timestamp;
        lotteryendtime = lotterystarttime + lotterytime;
    }

    function gettickettoken(uint256 amount) external payable {
        if (state != State.Lotterytime) {
            revert NotInRighState();
        }
        uint256 price = amount * ticketprice;
        if (price != msg.value) {
            revert NotEnoughMoneytoBuyTicket();
        }
        _mint(msg.sender, amount);
        ticketamount[msg.sender] += amount;
    }

    function getticket(uint256 amount) external {
        if (state != State.Lotterytime) {
            revert NotInRighState();
        }
        if (ticketamount[msg.sender] < amount) {
            revert NotEnoughTicket();
        }
        uint256[] memory ticketnumbers = new uint256[](amount);
        for (uint i = 1; i <= amount; i++) {
            ticketbox.push(TicketStructure(msg.sender, ticketentrynumber));
            ticketnumbers[i - 1] = ticketentrynumber; // Store the ticketentrynumber in the array
            ticketentrynumber++;
        }
        tickets[msg.sender] = ticketnumbers;
        ticketamount[msg.sender] -= amount;
    }

    function getmyTickets() public view returns (uint256[] memory) {
        if (state != State.Lotterytime) {
            revert NotInRighState();
        }
        uint256 amount = tickets[msg.sender].length;
        uint256[] memory tempticket = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++) {
            tempticket[i] = tickets[msg.sender][i]; // Corrected index
        }
        return tempticket;
    }
}
