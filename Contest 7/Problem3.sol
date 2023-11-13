// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address[] private players;
    mapping(address=>bool) isActive;
    address winner;
    uint256 gavinBalance;
    address private immutable gavin;
    constructor(){
        gavin=msg.sender;
    }
    
    // For participants to enter the pool
    function enter() public payable {
        address player=msg.sender;
        uint8 addition;
        if(msg.sender==winner){addition=1;}
        uint256 entryamount=100000000000000000 wei+(addition)*(10000000000000000 wei);
        (bool success,)=gavin.call{value:(entryamount*10)/100 }("");
        gavinBalance+=(entryamount*10)/100;
        if(msg.value!=entryamount || !success || player==gavin || isActive[player])revert();
        players.push(player);
        isActive[player]=true;
        uint256 num_of_player=players.length;
        if(num_of_player==5){
           getPaid();       
        }


    }
    function getPaid()internal{
        uint256 winnerIndex=getRandomNumber();
        address winnerAddress=players[winnerIndex-1];
        (bool success,)=winnerAddress.call{value: address(this).balance}("");
        assembly{
         if iszero(success) {
            revert(0, 0)
        }
        }
        winner=winnerAddress;
        for(uint256 i=0;i<5;i++){
            address index=players[i];
            isActive[index]=false;
        }   
        assembly {
    // Load the `isActive` mapping slot

         for { let i := 0 } lt(i, 5) { i := add(i, 1) } {
        // Load the player's address from the `players` array
        let player := sload(add(sload(players.slot), mul(i, 0x20)))

        // Set `isActive[player]` to false (0)
        sstore(add(isActive.slot, player), 0)
           }
      }
        assembly{
            sstore(players.slot, 0)

        }

    }

    // For participants to withdraw from the pool
    function withdraw() public {
        require(isActive[msg.sender]);
        (bool success,)=msg.sender.call{value: 90000000000000000 wei}("");
        // require(success);
        assembly{
         if iszero(success) {
            revert(0, 0)
        }
        }
        isActive[msg.sender]=false;
        uint256 length=players.length;
        address[] storage temp=players;
        for(uint256 i=0;i<length;i++){
            if(temp[i]==msg.sender){
                temp[i]=temp[length-1];
                temp.pop();
                return;
            }
        }

    }

    // To view participants in current pool
    function viewParticipants() public view returns (address[] memory, uint) {
        return (players,players.length);
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
         if(winner==address(0))revert();
        return winner;
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint) {
        require(msg.sender==gavin);
        return gavinBalance;
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint) {

        return address(this).balance;
    }

      function getRandomNumber() internal view returns (uint256) {
        uint256 randomNumber = uint256(keccak256(abi.encodePacked(block.timestamp))) % 5 + 1;
        return randomNumber;
    }
}