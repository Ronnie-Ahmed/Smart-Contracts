// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LotteryPool {
    mapping(address => bool) isActive;
    address winner;
    address[] private players;

    // For participants to enter the pool
    function enter() public payable {
        address player = msg.sender;
        unchecked {
            if (msg.value != .1 ether || isActive[player]) revert();
            players.push(player);
        }

        isActive[player] = true;
        uint8 num_of_player = uint8(players.length);
        if (num_of_player == 5) {
            getPaid();
        }
    }

    function getPaid() internal {
        uint8 winnerIndex = getRandomNumber();
        unchecked {
            address winnerAddress = players[winnerIndex - 1];
            payable(winnerAddress).transfer(address(this).balance);

            winner = winnerAddress;

            for (uint256 i = 0; i < 5; i++) {
                isActive[players[i]] = false;
            }
        }

        assembly {
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

    function getRandomNumber() internal view returns (uint8) {
        unchecked {
            uint256 randomNumber = (uint256(
                keccak256(abi.encodePacked(block.number))
            ) % 5) + 1;
            return uint8(randomNumber);
        }
    }
}
