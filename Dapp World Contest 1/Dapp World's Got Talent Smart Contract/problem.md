# Dapp World's Got Talent Smart Contract

Dapp-World's Got Talent is a show that has come to its season finale. The winner of the show will be decided based on votes from the audience and judges. The weightage of the votes of judges will be different than that of the audience. The points will be assigned to each finalist based on the number of votes each of the finalists receive from the audience and the judges. The contestant with the highest points will be the winner.

## Voting Process Flow

The voting process must follow these steps:

1. **Before the Start of Voting Process**

   - The addresses of the judges and finalists should be finalized and entered into the smart contract.
   - The weightage of the votes for the judges and the finalists should also be finalized and entered into the smart contract.
   - Only the owner of the smart contract is allowed to enter these details into the smart contract.
   - Only after having these details, the voting procedure can be started.

2. **After the Start of Voting Process**

   - After checking that all the details have been entered, the voting can be started only by the owner/deployer of the smart contract.
   - After starting the process, no one, including the owner of the smart contract, is allowed to enter or modify the details about judges, finalists, or the weightage.
   - Everyone can start casting votes for the finalists.

3. **Ending the Process of Voting**

   - After the voting interval is finished, the voting procedure should end. Only the owner has access to end the voting process.
   - As soon as the voting procedure ends, the smart contract must find the winner of the contest.
   - If there are multiple winners, the smart contract should consider all of them.
   - After the voting has ended, no one, including the owner of the smart contract, can access any function other than just viewing the winner.

4. **Results**
   - After the voting ends, everyone can see the winner/winners.

## Smart Contract Functions

The smart contract must be accessible through the following public functions:

### `selectJudges(address[] arrayOfAddresses)`

- Using this function, the owner of the smart contract can add addresses of the accounts of judges.
- The panel of judges can be replaced by running the same function with updated parameters.

### `inputWeightage(uint judgeWeightage, uint audienceWeightage)`

- Using this function, the weightage of the judges and audiences will be sent to the smart contract.
- The points of a finalist will be calculated as follows: Points = (number of audience who voted him/her _ audienceWeightage) + (number of judges who voted him/her _ judgeWeightage)
- The finalist with the maximum points will be considered the winner.

### `selectFinalists(address[] arrayOfAddresses)`

- Using this function, the owner of the smart contract can add addresses of the accounts of finalists.
- The finalists can be replaced by running the same function with updated parameters.
- The owner of the smart contract is allowed to vote but not allowed to be the judge or the participant.

### `startVoting()`

- Using this function, the owner of the smart contract will start the voting process.

### `castVote(address finalistAddress)`

- Using this function, the audience and judges can cast their vote for a finalist by selecting the address of the wallet of their favorite finalist.
- A person can change their vote during the voting process. The last vote casted will be considered.

### `endVoting()`

- Using this function, the owner of the smart contract will end the voting process.

## Function Outputs

The smart contract can be queried using the following public function:

### `showResult() returns (address[])`

- Using this function, everyone will be able to see the addresses of accounts of the winner/winners.

## Examples

Here is an example of how the smart contract functions work:

| Example | Function            | Sender Address | Parameter                  | Returns       |
| ------- | ------------------- | -------------- | -------------------------- | ------------- |
| 1       | `selectJudges()`    | Owner          | [<Address 1>, <Address 2>] | -             |
| 1       | `selectFinalists()` | Owner          | [<Address 3>, <Address 4>] | -             |
| 1       | `inputWeightage()`  | Owner          | [2, 3]                     | -             |
| 1       | `startVoting()`     | Owner          | -                          | -             |
| 1       | `castVote()`        | Owner          | <Address 3>                | -             |
| 2       | `castVote()`        | Address 1      | <Address 4>                | -             |
| 3       | `castVote()`        | Address 3      | <Address 3>                | -             |
| 1       | `endVoting()`       | Owner          | -                          | -             |
| 1       | `showResult()`      | Owner          | -                          | [<Address 3>] |

In this example, the owner of the smart contract selects judges, finalists, input weightage, and starts the voting process. Then, participants (including the owner) cast their votes for finalists. Finally, the owner ends the voting process and queries the winner/winners.
