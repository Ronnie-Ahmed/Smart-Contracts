# Token Sale Smart Contract (Modified)

You are tasked with modifying an existing smart contract called `TokenSale` to include additional features and constraints. The contract facilitates the sale and purchase of tokens, with the addition of a referral system and dynamic token price adjustment.

## Input

### `constructor(uint totalSupply, uint tokenPrice, uint saleDuration)`

The constructor function initializes the contract by setting the total supply of tokens, the token price in wei, and the duration of the token sale.

### `purchaseToken(address referrer)`

Allows users to purchase tokens by sending the required amount of ether. The referrer field cannot be empty. When a user purchases tokens, the referral system is triggered, and the referrer receives the appropriate percentage of tokens as a reward. The token price is adjusted based on the number of tokens bought and the remaining total supply. Tokens awarded to the referrer are deducted from the total supply.

### `sellTokenBack(uint amount)`

Allows users to sell their tokens back to the contract. The token price is adjusted based on the number of tokens sold. The user can only sell a maximum of 20% of their bought tokens in a week.

## Output

### `checkTokenPrice() returns (uint)`

Returns the current token price in wei.

### `checkTokenBalance(address buyer) returns (uint)`

Returns the token balance of a given buyer.

### `saleTimeLeft(address buyer) returns (uint)`

Returns the remaining time for the token sale in seconds. If the sale has ended, the transaction should fail.

### `getReferralCount(address referrer) returns (uint)`

Returns the number of referrals made by a given referrer.

### `getReferralRewards(address referrer) returns (uint)`

Returns the total number of tokens rewarded to a given referrer.

## Example 1

| Input/Output | Function/Constructor | Sender address | Parameter                    | Value(Wei) | Expected output  |
| ------------ | -------------------- | -------------- | ---------------------------- | ---------- | ---------------- |
| Input        | constructor()        | Owner          | (100000, 10000, 10000000000) | -          | -                |
| Input        | purchaseToken()      | Address 1      | (<Address 1>)                | 500000000  | Transaction Fail |
| Input        | purchaseToken()      | Address 1      | (<Owner>)                    | 500000000  | -                |
| Input        | purchaseToken()      | Address 1      | (<Owner>)                    | 500000000  | Transaction Fail |
| Output       | checkTokenBalance()  | Address 1      | (<Address 1>)                | -          | 50000            |
| Output       | getReferralCount()   | Address 1      | (<Owner>)                    | -          | 1                |
| Output       | getReferralRewards() | Address 1      | (<Owner>)                    | -          | 2500             |
| Output       | checkTokenPrice()    | Address 1      | -                            | -          | 12500            |
| Output       | getReferralCount()   | Address 1      | (<Address 1>)                | -          | 0                |
| Output       | getReferralRewards() | Address 1      | (<Address 1>)                | -          | 0                |
