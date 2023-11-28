// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    address[] private players;
    mapping(address => bool) isActive;
    address winner;
    uint256 gavinBalance;
    address public immutable gavin = msg.sender;

    // For participants to enter the pool
    function enter() public payable {
        address player = msg.sender;
        uint8 addition;
        unchecked {
            assembly {
                let winner2 := sload(winner.slot)
                if eq(player, winner2) {
                    addition := 1
                }
            }
            uint256 entryamount = 100000000000000000 wei +
                (addition) *
                (10000000000000000 wei);
            uint256 gavinget = (entryamount * 10) / 100;

            payable(gavin).transfer(gavinget);
            gavinBalance += gavinget;
            if (msg.value != entryamount || player == gavin || isActive[player])
                revert();
        }
        players.push(player);
        isActive[player] = true;
        uint256 num_of_player = players.length;
        if (num_of_player == 5) {
            getPaid();
        }
    }

    function getPaid() internal {
        uint256 winnerIndex = getRandomNumber();
        address winnerAddress = players[winnerIndex - 1];

        payable(winnerAddress).transfer(address(this).balance);
        assembly {
            sstore(winner.slot, winnerAddress)
            mstore(0, winnerAddress)
            mstore(32, isActive.slot)
            let hash := keccak256(0, 64)
            sstore(hash, 0)
            sstore(players.slot, 0)
        }
    }

    // For participants to withdraw from the pool
    function withdraw() public {
        payable(msg.sender).transfer(90000000000000000);

        assembly {
            mstore(0, caller())
            mstore(32, isActive.slot)
            let hash := keccak256(0, 64)
            sstore(hash, 0)
            sstore(players.slot, 0)
        }
    }

    // To view participants in current pool
    function viewParticipants() public view returns (address[] memory, uint) {
        return (players, players.length);
    }

    // To view winner of last lottery
    function viewPreviousWinner() public view returns (address) {
        if (winner == address(0)) revert();
        return winner;
    }

    // To view the amount earned by Gavin
    function viewEarnings() public view returns (uint) {
        require(msg.sender == gavin);
        return gavinBalance;
    }

    // To view the amount in the pool
    function viewPoolBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getRandomNumber() internal view returns (uint256) {
        unchecked {
            uint256 randomNumber = (block.timestamp % 5) + 1;
            return randomNumber;
        }
    }
}
