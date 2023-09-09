# Team Wallet - Hard

This is a hard version of the Team Wallet problem. In addition to the previous version, an additional function, `transactionStats`, needs to be implemented.

## Smart Contract Specifications

- The smart contract will be deployed by the DApp World Arena Judge.
- The deployer initializes the smart contract with the addresses of all the members of Pied Piper and the winning prize credit amount.
- Team members can create transaction requests to spend credits from the smart contract.
- Approval from at least 70% of the team members is required for a transaction to be completed.
- Rejection by more than 30% of the team members marks a transaction as failed.
- A transaction request with a spending amount greater than the available credits in the wallet automatically fails.

## Smart Contract Functions

The smart contract must contain the following public functions:

### `setWallet(address[] members, uint credits) public`

- Accessible only to the deployer of the smart contract (DApp World Arena Judge).
- Initializes the smart contract with the addresses of all the members of the winning team.
- The `members` array contains at least one member address.
- The `credits` must be strictly greater than 0.
- The deployer of the smart contract cannot be a member of the team.
- This function can only execute once and should not be callable once successfully executed.

### `spend(uint amount) public`

- Accessible only to the winning team members.
- Allows a team member to record a transaction request to the smart contract.
- The `amount` should be strictly greater than 0.
- By default, an approval is recorded for the transaction from the member who is sending the transaction request.
- Any spend request would be recorded in the smart contract irrespective of the amount, even if the amount exceeds the available credits.

### `approve(uint n) public`

- Accessible only to the winning team members.
- Allows a team member to record an approval for the nth transaction request sent to the smart contract.
- This function reverts if the team member has already approved or rejected the nth transaction request.

### `reject(uint n) public`

- Accessible only to the winning team members.
- Allows a team member to record a rejection for the nth transaction request sent to the smart contract.
- This function reverts if the team member has already approved or rejected the nth transaction request.

### `credits() returns (uint)`

- Accessible only to the winning team members.
- Returns the current available credits in the wallet.

### `viewTransaction(uint n) returns (uint amount, string status)`

- Accessible only to the winning team members.
- Returns the amount and status of the nth transaction request.
- `amount` is the spent amount requested for the nth transaction request.
- `status` can be one of the following:
  - "pending" if the transaction request is pending.
  - "debited" if the transaction request has been executed, and the credits have been spent.
  - "failed" if the transaction request has failed.

### `transactionStats() returns (uint debitedCount, uint pendingCount, uint failedCount)`

- Accessible only to the winning team members.
- Returns three values as follows:
  - `debitedCount`: the number of transaction requests that have been executed successfully.
  - `pendingCount`: the number of transaction requests that are pending.
  - `failedCount`: the number of transaction requests that have failed.

## Example

Here is an example of how the smart contract functions work:

| Example | Function Call        | Sender Address | Parameter                          | Returns          |
| ------- | -------------------- | -------------- | ---------------------------------- | ---------------- |
| 1       | `setWallet()`        | Owner          | ([<Address 1>, <Address 2>], 1000) | -                |
| 2       | `spend()`            | Address 1      | (100)                              | -                |
| 3       | `viewTransaction()`  | Address 1      | (1)                                | [100, "pending"] |
| 4       | `approve()`          | Address 2      | (1)                                | -                |
| 5       | `viewTransaction()`  | Address 2      | (1)                                | [100, "debited"] |
| 6       | `transactionStats()` | Address 1      | -                                  | [1, 0, 0]        |

In this example, the owner (DApp World Arena Judge) sets up the wallet with two team members and 1000 credits. Team member 1 initiates a spend request for 100 credits. Then, team member 2 approves the spend request. Finally, both team members can view the transaction, which is marked as "debited" because it was approved and executed successfully. The `transactionStats` function shows that there is 1 debited transaction, 0 pending transactions, and 0 failed transactions.
