// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Interface for the Gaming Ecosystem NFT contract
interface IGamingEcosystemNFT {
    function mintNFT(address to) external;

    function burnNFT(uint256 tokenId) external;

    function transferNFT(uint256 tokenId, address from, address to) external;
}

// Main contract for the Blockchain Gaming Ecosystem
contract BlockchainGamingEcosystem {
    uint8 private counter; // Counter for NFT IDs
    address immutable contractOwner; // Owner of the contract
    address immutable nftContractAddress; // Address of the NFT contract

    // Constructor function to initialize the contract
    constructor(address _nftAddress) {
        contractOwner = msg.sender;
        nftContractAddress = _nftAddress;
        counter = 0;
    }

    // Struct for storing game details
    struct Game {
        uint8 gameID; // ID of the game
        uint16 currentAssetPrice; // Current price of the game asset
        bool isGameOn; // Flag to indicate if the game is active
    }

    // Struct for storing NFT asset details
    struct NftAssetDetails {
        uint8 tokenId; // ID of the NFT asset
        address assetOwner; // Owner of the NFT asset
        uint8 gameId; // ID of the game associated with the NFT asset
        uint16 assetPrice; // Price of the NFT asset
        bool isNftIdExist; // Flag to indicate if the NFT asset exists
    }

    // Struct for storing player details
    struct Player {
        address PlayerAddress; // Address of the player
        string PlayerName; // Name of the player
        uint16 PlayerCredits; // Credits of the player
        uint8 NFTcount; // Number of NFT assets owned by the player
        bool isPlayerRegistered; // Flag to indicate if the player is registered
    }

    // Mapping to store player details
    mapping(address => Player) addressToPlayer;

    // Mapping to store NFT asset details
    mapping(uint256 => NftAssetDetails) private itToNFT;

    // Mapping to store game details
    mapping(uint256 => Game) private gameToId;

    // Mapping to store if a username is taken
    mapping(string => bool) private isUserNameTaken;

    // Mapping to store if a game name is taken
    mapping(string => bool) private isGameNameTaken;

    // Mapping to store NFT IDs associated with a game
    mapping(uint256 => uint8[]) private gameNftIds;

    // Mapping to store game names associated with game IDs
    mapping(uint8 => string) private gameIdToname;

    // Function to register as a player
    function registerPlayer(string calldata userName) public {
        if (
            msg.sender == contractOwner ||
            addressToPlayer[msg.sender].isPlayerRegistered ||
            isUserNameTaken[userName]
        ) revert();

        bytes calldata strBytes = bytes(userName);

        assembly {
            if lt(strBytes.length, 3) {
                revert(0, 0)
            }
        }

        addressToPlayer[msg.sender] = Player(
            msg.sender,
            userName,
            1000,
            0,
            true
        );

        isUserNameTaken[userName] = true;
    }

    // Function to create a new game
    function createGame(string calldata gameName, uint256 gameID) public {
        if (
            isGameNameTaken[gameName] ||
            gameToId[gameID].isGameOn ||
            msg.sender != contractOwner
        ) revert();
        unchecked {
            gameToId[gameID] = Game(uint8(gameID), 250, true);
            gameIdToname[uint8(gameID)] = gameName;
            isGameNameTaken[gameName] = true;
        }
    }

    // Function to remove a game from the ecosystem
    function removeGame(uint256 gameID) public {
        if (msg.sender != contractOwner || !gameToId[uint8(gameID)].isGameOn)
            revert();
        unchecked {
            uint8[] storage nftIds = gameNftIds[gameID];

            for (uint8 i = 0; i < nftIds.length; i++) {
                address owner = itToNFT[nftIds[i]].assetOwner;
                addressToPlayer[owner].NFTcount -= 1;
                addressToPlayer[owner].PlayerCredits += itToNFT[nftIds[i]]
                    .assetPrice;
                itToNFT[nftIds[i]].isNftIdExist = false;
                IGamingEcosystemNFT(nftContractAddress).burnNFT(nftIds[i]);
            }
        }

        gameToId[gameID].isGameOn = false;
    }

    // Function to allow players to buy an NFT asset
    function buyAsset(uint256 gameID) public {
        unchecked {
            uint16 currentPrice = gameToId[uint8(gameID)].currentAssetPrice;
            if (
                addressToPlayer[msg.sender].isPlayerRegistered == false ||
                !gameToId[gameID].isGameOn ||
                addressToPlayer[msg.sender].PlayerCredits < currentPrice
            ) revert();

            IGamingEcosystemNFT(nftContractAddress).mintNFT(msg.sender);
            addressToPlayer[msg.sender].PlayerCredits -= currentPrice;
            gameToId[gameID].currentAssetPrice = (currentPrice * 11) / 10;
            addressToPlayer[msg.sender].NFTcount += 1;

            // Store the NFT ID associated with the game
            uint8 nftId = counter;
            gameNftIds[gameID].push(nftId);

            itToNFT[counter] = NftAssetDetails(
                nftId,
                msg.sender,
                uint8(gameID),
                currentPrice,
                true
            );
            nftId += 1;
            counter = nftId;
        }
    }

    // Function to allow players to sell owned assets
    function sellAsset(uint256 tokenID) public {
        if (
            addressToPlayer[msg.sender].isPlayerRegistered == false ||
            itToNFT[uint8(tokenID)].assetOwner != msg.sender ||
            itToNFT[tokenID].isNftIdExist == false
        ) revert();
        unchecked {
            uint8 gameid = itToNFT[tokenID].gameId;

            addressToPlayer[msg.sender].PlayerCredits += gameToId[gameid]
                .currentAssetPrice;

            IGamingEcosystemNFT(nftContractAddress).burnNFT(tokenID);
            addressToPlayer[msg.sender].NFTcount -= 1;

            // Remove the NFT ID from the game's list
            uint8[] storage nftIds = gameNftIds[gameid];

            for (uint8 i = 0; i < nftIds.length; i++) {
                if (nftIds[i] == uint8(tokenID)) {
                    // Swap and pop to remove the element efficiently
                    nftIds[i] = nftIds[nftIds.length - 1];
                    nftIds.pop();
                    break;
                }
            }
        }
    }

    // Function to transfer asset to a different player
    function transferAsset(uint256 tokenID, address to) public {
        if (
            itToNFT[tokenID].assetOwner != msg.sender ||
            to == msg.sender ||
            addressToPlayer[to].isPlayerRegistered == false ||
            addressToPlayer[msg.sender].isPlayerRegistered == false ||
            !itToNFT[tokenID].isNftIdExist
        ) revert();
        unchecked {
            IGamingEcosystemNFT(nftContractAddress).transferNFT(
                tokenID,
                msg.sender,
                to
            );
            addressToPlayer[msg.sender].NFTcount -= 1;

            addressToPlayer[to].NFTcount += 1;

            itToNFT[uint8(tokenID)].assetOwner = to;
        }
    }

    // Function to view a player's profile
    function viewProfile(
        address playerAddress
    )
        public
        view
        returns (string memory userName, uint256 balance, uint256 numberOfNFTs)
    {
        require(
            addressToPlayer[msg.sender].isPlayerRegistered ||
                msg.sender == contractOwner,
            "Not a Registered Player"
        );
        require(
            addressToPlayer[playerAddress].isPlayerRegistered,
            "Transaction Failed"
        );
        userName = addressToPlayer[playerAddress].PlayerName;
        balance = addressToPlayer[playerAddress].PlayerCredits;
        numberOfNFTs = addressToPlayer[playerAddress].NFTcount;
    }

    // Function to view Asset owner and the associated game
    function viewAsset(
        uint256 tokenID
    ) public view returns (address owner, string memory gameName, uint price) {
        if (
            !addressToPlayer[msg.sender].isPlayerRegistered &&
            msg.sender != contractOwner
        ) revert();

        require(itToNFT[tokenID].isNftIdExist);

        owner = itToNFT[tokenID].assetOwner;
        gameName = gameIdToname[uint8(itToNFT[tokenID].gameId)];
        price = itToNFT[tokenID].assetPrice;
    }

    function getCounter() public view returns (uint8) {
        return counter;
    }

    function getOwner() public view returns (address) {
        return contractOwner;
    }

    function getNftAddress() public view returns (address) {
        return nftContractAddress;
    }

    function getplayer(address _address) public view returns (Player memory) {
        return addressToPlayer[_address];
    }

    function getNft(
        uint256 _tokenId
    ) public view returns (NftAssetDetails memory) {
        return itToNFT[_tokenId];
    }

    function getGame(uint256 _gameId) public view returns (Game memory) {
        return gameToId[_gameId];
    }

    function getGameNftIds(
        uint256 _gameId
    ) public view returns (uint8[] memory) {
        return gameNftIds[_gameId];
    }

    function getGameName(uint256 _gameId) public view returns (string memory) {
        return gameIdToname[uint8(_gameId)];
    }
}
