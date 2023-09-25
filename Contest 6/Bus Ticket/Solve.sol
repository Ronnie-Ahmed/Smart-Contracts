// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TicketBooking {
    uint8[20] private seatlist;
    mapping(uint8 => bool) private isAvailable;
    mapping(address => uint256[]) private mySeatlist;
    mapping(address => uint8) private howManySeat;

    constructor() {
        for (uint8 i = 0; i < 20; i++) {
            seatlist[i] = i + 1;
            isAvailable[i + 1] = true;
        }
    }

    // To book seats
    function bookSeats(uint256[] calldata seatNumbers) public {
      unchecked{ 
          uint8 count = 0;


        assembly{
            if lt (seatNumbers.length,1){revert(0,0)}
            if gt(seatNumbers.length,4){revert(0,0)}

        }

        for (uint256 i = 0; i < seatNumbers.length; i++) {
            uint8 seatNumber = uint8(seatNumbers[i]);
             assembly{
                     if lt (seatNumber,1){revert(0,0)}
                     if gt(seatNumber,20){revert(0,0)}
                   }
            require(isAvailable[seatNumber]);
            mySeatlist[msg.sender].push(seatNumber);
            count++;
            isAvailable[seatNumber] = false;
        }

        require(howManySeat[msg.sender] + count <= 4);
        howManySeat[msg.sender] += count;}
       
    }

    // To get available seats
    function showAvailableSeats() public view returns (uint256[] memory) {
       unchecked{
         uint8 count = 0;
        uint256[] memory tempArray = new uint256[](20);

        for (uint8 i = 0; i < 20; i++) {
            uint8 seatNumber =uint8(seatlist[i]);
            if (isAvailable[seatNumber]) {
                tempArray[count] = seatNumber;
                count++;
            }
        }

        assembly {
            mstore(tempArray, count)
        }

        return tempArray;
       }
       
    }

    // To check availability of a seat
    function checkAvailability(uint256 seatNumber) public view returns (bool) {
        require(uint8(seatNumber) >= 1 && uint8(seatNumber) <= 20);
        return isAvailable[uint8(seatNumber)];
    }

    // To check tickets booked by the user
    function myTickets() public view returns (uint256[] memory) {
        return mySeatlist[msg.sender];
    }
}
