// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Auction {
    address public auctionowner;
    address public highesthidder;
    uint256 public highestbid;
    uint256 auctionduration;
    bool isAuctionended;
    mapping(address => uint256) public bids;
    uint256[] hightbid;
    struct Bidderdetails {
        address bideraddress;
        uint256 bidamount;
    }
    mapping(uint256 => Bidderdetails) public bidder;
    uint256 count = 0;

    constructor(uint256 _auctionduration) {
        auctionduration = _auctionduration + block.timestamp;
        auctionowner = msg.sender;
    }

    function bidStart() external payable {
        require(msg.value > highestbid, "Your Bid is too low");
        require(block.timestamp < auctionduration, "Auction has ended");
        require(isAuctionended != true, "Auction ended, start a new auction");
        if (highesthidder != address(0)) {
            bids[highesthidder] += highestbid;
        }
        highesthidder = msg.sender;
        highestbid = msg.value;
        hightbid.push(highestbid);
        bidder[count] = Bidderdetails(msg.sender, msg.value);
        count++;
    }

    function endAuction() external {
        require(
            msg.sender == auctionowner,
            "Only Owner can call this function"
        );
        require(block.timestamp >= auctionduration, "Auction have time left");
        count = 0;
        isAuctionended = true;

        uint256 amount = bids[highesthidder];

        (bool success, ) = auctionowner.call{value: amount}("");
        require(success, "Auction has ended");
    }

    function withdraw() external {
        require(block.timestamp >= auctionduration, "Auction have time left");
        uint256 amount = bids[msg.sender];
        if (amount > 0) {
            bids[msg.sender] = 0;
            (bool success, ) = msg.sender.call{value: amount}("");
            require(success, "Withdraw failed");
        }
    }

    function viewAllbids() public view returns (Bidderdetails[] memory) {
        Bidderdetails[] memory temparray = new Bidderdetails[](count);
        for (uint i = 0; i < count; i++) {
            temparray[i] = bidder[i];
        }
        return temparray;
    }

    function createNewAuction(uint256 _auctionDuration) external {
        require(isAuctionended, "Previous Auction not done");
        auctionowner = msg.sender;
        auctionduration = block.timestamp + _auctionDuration;
        highestbid = 0;
        highesthidder = address(0);
    }
}
