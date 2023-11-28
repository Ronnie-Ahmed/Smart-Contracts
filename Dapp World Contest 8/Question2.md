# Automatic Lottery System - Smart Contract (Easy)

Gavin, inspired by a blockchain-based lottery system in Estonia, has decided to create a self-managing lottery system in his own country. The smart contract eliminates the need for manual management and ensures a fair lottery experience.

## Lottery System Rules

1. Anyone can enter the lottery pool by paying exactly 0.1 ethers.
2. The pool requires 5 participants to be filled completely.
3. Once the 5th player enters the lottery pool, the smart contract randomly selects 1 winner, and all the amount in the pool is transferred to the winner.
4. The pool is emptied after a lottery is completed, and the smart contract starts a new round of the lottery for the next 5 players.

## Public Functions

### `enter()`

- A payable function accepting exactly 0.1 ethers.
- Reverts for any other amount of eth.
- Participants can enter the lottery pool using this function.
- After 5 participants enter, a random winner is selected, and funds are transferred to the winner.
- The pool is emptied, and a new round starts.
- Participants cannot re-enter the current active lottery.

### `viewParticipants()`

- A view function with stateMutability as view.
- Returns:
  - An array of addresses of players in the current pool, in order of participation.
  - Number of players who have participated in the current active lottery.
  - Returns [\[ \], 0] if no player has participated yet.

### `viewPreviousWinner()`

- A view function returning the winner of the previous lottery.
- Reverts if no lottery has been completed.

## Example 1

### Input/Output

#### Function: `viewParticipants()`

- Sender Address: Address 3
- Parameter: None
- Value(Eth): None
- Expected Return: `[[] , 0]`

#### Function: `enter()`

- Sender Address: Owner
- Parameter: None
- Value(Eth): 0.1
- Expected Return: None

#### Function: `viewParticipants()`

- Sender Address: Address 2
- Parameter: None
- Value(Eth): None
- Expected Return: `[[<Owner>] , 1]`

#### Function: `enter()`

- Sender Address: Address 1
- Parameter: None
- Value(Eth): 0.1
- Expected Return: None

#### Function: `viewParticipants()`

- Sender Address: Address 1
- Parameter: None
- Value(Eth): None
- Expected Return: `[[<Owner>,<Address 1>] , 2]`
