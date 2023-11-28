// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SolahParchiThap {
    address immutable owner;

    constructor() {
        owner = msg.sender;
    }

    address[4] public _players;
    uint8[4][4] public _parchis;
    bool public isGameInProgress;
    mapping(address => uint8[4]) public per_parchis;
    mapping(address => bool) public isAplayer;
    address public turn;
    uint8 public turnpoint;
    uint256 startGameTime;
    uint256 EndGame;
    mapping(address => uint8) playerwins;

    function setState(
        address[4] memory players,
        uint8[4][4] memory parchis
    ) public {
        require(msg.sender == owner);
        require(!isGameInProgress);

        for (uint8 i = 0; i < 4; i++) {
            address CurrentAddress = players[i];

            require(CurrentAddress != owner);
            require(CurrentAddress != address(0));
            isAplayer[CurrentAddress] = true;
            _players[i] = CurrentAddress;
            for (uint8 j = 0; j < 4; j++) {
                uint8 num = parchis[i][j];
                per_parchis[CurrentAddress][j] = num;
                _parchis[i][j] = parchis[i][j];
            }
        }
        if (!check(players)) {
            revert();
        }
        turn = players[0];
        startGameTime = block.timestamp;
        EndGame = block.timestamp + 1 hours;
        isGameInProgress = true;
    }

    function check(address[4] memory players) internal view returns (bool) {
        uint8 player1;
        uint8 player2;
        uint8 player3;
        uint8 player4;
        bool checking = true;
        for (uint8 i = 0; i < 4; i++) {
            uint8[4] memory temp = per_parchis[players[i]];
            for (uint8 j = 0; j < 4; j++) {
                if (i == 0) {
                    player1 += temp[j];
                } else if (i == 1) {
                    player2 += temp[j];
                } else if (i == 2) {
                    player3 += temp[j];
                } else {
                    player4 += temp[j];
                }
            }
        }
        uint256 total = player1 + player2 + player3 + player4;

        if ((player1 != 3 && player1 != 4) || player1 == 5 || total != 16) {
            checking = false;
        }
        return checking;
    }

    // To pass the parchi to next player
    function passParchi(uint8 parchi) public {
        uint8 parchi_ = parchi;
        address caller = msg.sender;

        require(isAplayer[caller]);
        require(parchi_ > 0 && parchi_ < 5);
        require(turn == caller);

        per_parchis[caller][parchi_ - 1] -= 1;
        turnpoint += 1;
        if (turnpoint > 3) {
            turnpoint = 0;
        }
        turn = _players[turnpoint];
        per_parchis[turn][parchi_ - 1] += 1;
    }

    // To claim win
    function claimWin() public {
        address caller = msg.sender;
        require(isAplayer[caller]);
        for (uint8 i = 0; i < 4; i++) {
            isAplayer[_players[i]] = false;
            if (per_parchis[caller][i] == 4) {
                playerwins[caller] += 1;
                isGameInProgress = false;
            }
        }
        if (isGameInProgress) {
            revert();
        }
        delete _players;
        delete _parchis;
    }

    // To end the game
    function endGame() public {
        require(block.timestamp > EndGame);
        require(isAplayer[msg.sender]);
        isGameInProgress = false;
        for (uint8 i = 0; i < 4; i++) {
            isAplayer[_players[i]] = false;
        }
        delete _players;
        delete _parchis;
    }

    // To see the number of wins
    function getWins(address add) public view returns (uint256) {
        require(add != owner && add != address(0));
        return playerwins[add];
    }

    // To see the parchis held by the caller of this function
    function myParchis() public view returns (uint8[4] memory) {
        require(isAplayer[msg.sender]);
        return per_parchis[msg.sender];
    }

    // To get the state of the game
    function getState()
        public
        view
        returns (address[4] memory, address, uint8[4][4] memory)
    {
        require(msg.sender == owner);

        require(isGameInProgress);
        uint8[4][4] memory temp;
        address[4] memory tempPlayer = _players;
        for (uint8 i = 0; i < 4; i++) {
            address CurrentAddress = tempPlayer[i];
            for (uint8 j = 0; j < 4; j++) {
                temp[i][j] = per_parchis[CurrentAddress][j];
            }
        }
        return (tempPlayer, turn, temp);
    }
}
