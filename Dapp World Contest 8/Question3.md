# Automatic Lottery System - Smart Contract

Gavin, inspired by a blockchain-based lottery system in Estonia, has decided to create a self-managing lottery system. The smart contract is designed to eliminate manual management and ensure fair participation while generating income for Gavin.

## Rules of the Lottery System

1. Gavin is the deployer of the contract, and participants (excluding Gavin) can enter the lottery pool by paying an amount calculated as "0.1 + (number of games won)\*(0.01)" ethers. The entry fees (10%) go to Gavin's account, and the remaining amount goes to the contract address.

2. The lottery pool requires 5 participants to be filled completely.

3. Once the 5th player enters the pool, the smart contract randomly selects 1 winner, and all the funds in the pool are transferred to the winner. The pool is then emptied, and a new round of the lottery begins for the next 5 players.

4. Before 5 players enter the pool, a participant can withdraw and receive the amount paid (excluding entry fees).

## Public Functions

### `enter()`

- A payable function allowing participants to enter the lottery pool by paying the calculated amount in ethers.
- After 5 participants enter, a random winner is selected, and funds are transferred to the winner.
- The pool is emptied, and a new round starts.
- Participants cannot re-enter an active lottery unless they withdraw and enter again.

### `withdraw()`

- Allows a participant to withdraw from the current active pool.
- If the participant is not part of the current active pool, the transaction reverts.

### `viewParticipants()`

- A view function returning:
  - Array of addresses of players in the current pool, in order of participation.
  - Number of players who have participated in the current active lottery.

### `viewPreviousWinner()`

- A view function returning the winner of the previous lottery.
- Reverts if no lottery has been completed.

### `viewEarnings()`

- A view function accessible only to Gavin, returning the ethers earned by Gavin as profit from the contract.

### `viewPoolBalance()`

- A view function returning the ethers in wei units present in the pool or the deployed lottery contract.

## Example

### Input/Output

#### Function: `viewParticipants()`

- Sender Address: Address 3
- Parameter: None
- Value(Eth): None
- Expected Return: `[[] , 0]`

#### Function: `enter()`

- Sender Address: Address 3
- Parameter: None
- Value(Eth): 0.1
- Expected Return: None

#### Function: `viewParticipants()`

- Sender Address: Address 2
- Parameter: None
- Value(Eth): None
- Expected Return: `[[<Address 3>] , 1]`

#### Function: `enter()`

- Sender Address: Address 1
- Parameter: None
- Value(Eth): 0.1
- Expected Return: None

#### Function: `viewParticipants()`

- Sender Address: Address 1
- Parameter: None
- Value(Eth): None
- Expected Return: `[[<Address 3>,<Address 1>] , 2]`
