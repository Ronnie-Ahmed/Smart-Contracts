# Scholarship Credit System - Easy

Pied Piper is an organization that provides scholarships to students for their educational needs. They have introduced a credit system using smart contracts and blockchain technology to prevent misspending. Credits are assigned to students and can only be transferred to approved merchants. Here are the requirements:

- The total number of credits is 1,000,000, initially held by the contract owner, Gavin.
- All addresses for owner, students, and merchants must be unique.
- A student can receive multiple scholarships.
- Merchants can receive credits, deregister their address, and cash in through Pied Piper.
- The smart contract must be accessible to students and merchants for transferring and receiving credits.

## Smart Contract Functions

The smart contract must contain the following public functions:

### `grantScholarship(address studentAddress, uint credits)`

- Accessible only to the owner of the contract.
- Owner assigns credits to the wallet address of a student.

### `registerMerchantAddress(address merchantAddress)`

- Accessible only to the owner of the contract.
- Owner registers a new merchant who can receive credits from students.

### `deregisterMerchantAddress(address merchantAddress)`

- Accessible only to the owner of the contract.
- Owner deregisters an existing merchant. This is done when the merchant has been credited an equivalent amount of cash money (out of scope for the contract).
- After deregistration, the student can't send credits to this merchant until they are registered again.

### `revokeScholarship(address studentAddress)`

- Accessible only to the owner of the contract.
- Owner revokes the scholarship of a student.
- Unspent credits assigned to the student are assigned back to Pied Piper, and the student can't spend any credits.

### `spend(address merchantAddress, uint amount)`

- Accessible only to students holding scholarships.
- Students transfer credits only to registered merchants.

## Function Outputs

The smart contract can be queried using the following public function:

### `checkBalance() returns (uint)`

- Accessible by scholarship-holding students, registered merchants, and the owner.
- Shows the available credits assigned to their address.

## Examples

Here is an example of how the smart contract functions work:

| Example | Function                    | Sender Address | Parameter             | Returns   |
| ------- | --------------------------- | -------------- | --------------------- | --------- |
| 1       | `registerMerchantAddress()` | Owner          | [<Address 9>]         | -         |
| 2       | `grantScholarship()`        | Owner          | [<Address 1>, 100000] | -         |
| 2       | `grantScholarship()`        | Owner          | [<Address 2>, 100000] | -         |
| 3       | `checkBalance()`            | Address 1      | -                     | [] 100000 |
| 4       | `spend()`                   | Address 1      | [<Address 9>, 50000]  | -         |
| 5       | `checkBalance()`            | Address 1      | -                     | [] 50000  |
| 6       | `checkBalance()`            | Address 2      | -                     | [] 100000 |
| 7       | `spend()`                   | Address 1      | [<Address 9>, 50000]  | -         |
| 8       | `checkBalance()`            | Address 1      | -                     | [] 0      |

In this example, the owner registers a merchant, grants scholarships to two students, checks their balances, and allows a student to spend credits at the registered merchant. Finally, the student checks their remaining balance.
