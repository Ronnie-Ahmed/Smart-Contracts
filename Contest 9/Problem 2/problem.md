# Token Sale Smart Contract

You have been assigned the task of developing a token sale smart contract for a project. A token sale contract manages the sale of digital tokens, representing ownership rights or access on a decentralized platform.

This contract outlines the rules of the token sale, including:

- The total number of tokens available for purchase.
- The price of each token in cryptocurrency.
- The duration of the sale period.
- How purchased tokens will be distributed among buyers.

The smart contract will facilitate the sale of tokens to the public with the following functionalities:

## Input

### `constructor(uint totalSupply, uint tokenPrice, uint saleDuration)`

The constructor function initializes the contract by setting the total supply of tokens, the token price in wei, and the duration of the token sale.

### `purchaseToken()`

This function allows an address to purchase tokens during the token sale. The address can only purchase tokens once. The function checks if the token sale is active, the amount sent is sufficient to purchase at least one token, and there are enough tokens available for purchase.

### `sellTokenBack(uint amount)`

This function allows a buyer to sell back a specified amount of tokens they have purchased. The user can only sell a maximum of 20% of their bought tokens in a week. The corresponding amount in wei is transferred back to the buyer's address.

## Output

### `checkTokenPrice() returns (uint)`

This function returns the current price of the tokens in wei.

### `checkTokenBalance(address buyer) returns (uint)`

This function returns the token balance of a specific buyer address.

### `saleTimeLeft(address buyer) returns (uint)`

This function returns the remaining time for the token sale in seconds. If the sale has ended, the transaction should fail.

## Example 1

| Input/Output | Function/Constructor | Sender address | Parameter        | Value(Wei) | Expected output  |
| ------------ | -------------------- | -------------- | ---------------- | ---------- | ---------------- |
| Input        | constructor()        | Owner          | (1000, 1, 10000) | -          | -                |
| Input        | purchaseToken()      | Address 1      | -                | 10         | -                |
| Input        | purchaseToken()      | Address 1      | -                | 10         | Transaction Fail |
| Input        | purchaseToken()      | Address 2      | -                | 10         | -                |
| Output       | checkTokenPrice()    | Address 1      | -                | -          | 1                |
| Output       | checkTokenBalance()  | Address 1      | <Address 1>      | -          | 10               |
