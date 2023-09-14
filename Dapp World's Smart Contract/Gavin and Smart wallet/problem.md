# Gavin and Smart Wallet

Gavin, a business owner, wants to create a wallet and develop a smart contract that he can deploy and own after verification. Gavin wants to be the sole person who can grant or revoke access to the wallet, and anyone with access should be able to add, spend, and view its balance. The wallet should have a maximum limit of 10,000 credits, and its balance should never exceed this amount. The wallet should start with an initial balance of 0.

## Smart Contract Functions

The smart contract must include the following public functions:

### `addFunds(uint amount)`

- Allows adding funds to the wallet's balance.
- The amount should not exceed 10,000 credits.
- Only Gavin and the addresses he has granted access to can use this function.

### `spendFunds(uint amount)`

- Allows spending funds from the wallet's balance.
- The balance cannot go negative.
- Only Gavin and the addresses he has granted access to can use this function.

### `addAccess(address x)`

- Grants access to address `x` to the smart contract.
- Only Gavin (contract owner) has the authority to execute this function.

### `revokeAccess(address y)`

- Revokes access to address `y` from the smart contract.
- Only Gavin (contract owner) has the authority to execute this function.

### `viewBalance()`

- Displays the current balance of the wallet.
- Only Gavin and the addresses he has granted access to can use this function.

## Example

Here's an example of how the smart wallet and contract work:

| Example | Function Call    | Sender Address | Parameter/Returns   |
| ------- | ---------------- | -------------- | ------------------- |
| 1       | `addAccess()`    | Address 1      | `<Address 2>`       |
| 2       | `addFunds()`     | Address 2      | 11,000              |
|         |                  |                | (Transaction fails) |
| 3       | `addFunds()`     | Address 2      | 10,000              |
| 4       | `spendFunds()`   | Address 2      | 10                  |
| 5       | `viewBalance()`  | Address 2      | 9,990               |
| 6       | `revokeAccess()` | Address 1      | `<Address 2>`       |
| 7       | `spendFunds()`   | Address 2      | 10                  |
|         |                  |                | (Transaction fails) |

In this example, Gavin grants access to Address 2. Address 2 tries to add 11,000 credits but fails because it exceeds the limit of 10,000. Then, Address 2 successfully adds 10,000 credits, spends 10 credits, views the balance, and finally, Gavin revokes access for Address 2. Address 2 attempts to spend another 10 credits, but the transaction fails because access has been revoked.

Gavin now has control over the wallet and can manage access and funds as needed.
