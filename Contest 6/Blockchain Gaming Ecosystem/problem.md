# Blockchain Gaming Ecosystem Smart Contract

## Overview

This smart contract is designed to create and manage a blockchain-based gaming ecosystem. The ecosystem comprises players, games, credits, and non-fungible tokens (NFTs) representing in-game assets. The contract allows players to register, purchase in-game assets, interact with these assets, and manage ownership and transfers of assets within the ecosystem.

## Rules

The following rules govern the blockchain gaming ecosystem:

- The contract deployer is designated as the owner.
- Any user can register as a player, except for the owner. Registered players receive 1000 credits upon registration.
- NFT tokenIDs start from 0 and increment by 1 for each newly minted NFT.
- The owner can create new games at any time after deploying the contract.
- Players can use credits to buy and sell in-game assets.
- The owner can remove games from the ecosystem, causing all associated assets to be destroyed, and players owning those assets to be refunded.
- Players can transfer their assets to other registered players.

## Functions

### Player Registration

- **registerPlayer(string memory userName)**: This function is accessible to everyone except the owner. Players can register with a unique username of at least 3 characters and receive 1000 credits upon registration.

### Game Management

- **createGame(string memory gameName, uint256 gameID)**: This function is exclusively available to the owner and is used to create new games with unique names and game IDs.

- **removeGame(uint256 gameID)**: This function is also only accessible by the owner and is used to remove a game. All assets associated with the game are destroyed, and players owning assets in the game are refunded with the credits used to purchase those assets.

### Asset Transactions

- **buyAsset(uint256 gameID)**: Registered players can use this function to buy in-game assets (NFTs) associated with a particular game using their credits. The price for the first asset of any game is 250, and it increments by 10% each time someone buys an asset for that game. A new NFT is minted with the player as the owner at the calculated price.

- **sellAsset(uint256 tokenID)**: Registered players can use this function to sell their in-game assets. The asset is destroyed, and the player receives credits at the current buying price for that particular game.

- **transferAsset(uint256 tokenID, address to)**: Registered players can use this function to transfer their in-game assets to other registered players.

## Example Usage

Here is an example of how the contract can be used:

1. Owner creates two games, "Game1" and "Game2".
2. Player Bob registers with the username "Bob" and receives 1000 credits.
3. Player Charlie registers with the username "Charlie" and receives 1000 credits.
4. Bob buys assets for both "Game1" and "Game2".
5. Charlie buys assets for "Game1".
6. Bob buys another asset for "Game1".
7. Owner views Bob's profile, which shows his username, balance, and the number of NFTs he owns.
8. Owner views Charlie's profile, which shows his username.
