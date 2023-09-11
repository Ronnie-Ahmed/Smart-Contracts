# Scholarship Credit System - Hard

Pied Piper is an organization dedicated to providing scholarships to students for their educational needs. They've decided to implement a credit system using smart contracts and blockchain technology to prevent misuse of funds. Instead of sending money directly, they will assign credits to students, which can only be used with approved merchants.

## Smart Contract Specifications

- The contract owner, Gavin, initially holds the total number of credits, which is 1,000,000. The owner and merchants do not have specific categories, and their balances will be stored in the 'all' category.
- All addresses for the owner, students, and merchants must be unique.
- Students can receive multiple scholarships.
- Merchants can only receive credits and can cash them out through Pied Piper. They can also deregister their address from the list of merchant addresses.

## Smart Contract Functions

The smart contract must contain the following public functions:

### `grantScholarship(address studentAddress, uint credits, string category)`

- Accessible only to the contract owner.
- Allows the owner to assign credits to a student's wallet address.
- The third parameter, 'category,' should have one of the following values: 'meal', 'academics', 'sports', or 'all'.

### `registerMerchantAddress(address merchantAddress, string category)`

- Accessible only to the contract owner.
- Enables the owner to register a new merchant who can receive credits from students.
- The second parameter, 'category,' should have one of the following values: 'meal', 'academics', or 'sports'.

### `deregisterMerchantAddress(address merchantAddress)`

- Accessible only to the contract owner.
- Allows the owner to deregister an existing merchant.
- This action is taken when the merchant has received an equivalent amount of cash, which falls outside the scope of the smart contract.
- After deregistration, students will not be able to send credits to this merchant until it is registered again.

### `revokeScholarship(address studentAddress)`

- Accessible only to the contract owner.
- Allows the owner to revoke a student's scholarship.
- After revocation, any unspent credits assigned to the student will be returned to Pied Piper, and the student will lose access to spending any credits.

### `spend(address merchantAddress, uint amount)`

- Accessible only to students holding scholarships.
- Allows students to transfer credits to registered merchants.
- Depending on the category of the registered merchant, the credits will be spent as follows:
  - 'meal' category merchants: First, 'meal' credits will be spent. If the 'meal' credits are exhausted, 'all' credits will be used to complete the transaction.
  - 'sports' category merchants: First, 'sports' credits will be spent. If the 'sports' credits are exhausted, 'all' credits will be used to complete the transaction.
  - 'academics' category merchants: First, 'academics' credits will be spent. If the 'academics' credits are exhausted, 'all' credits will be used to complete the transaction.

## Function Outputs

The smart contract can be queried using the following public functions:

### `checkBalance(string category) returns (uint)`

- Accessible by students holding scholarships, registered merchants, and the contract owner.
- Allows them to check the available credits assigned to their address by entering the category of the credits they want to check.

### `showCategory() returns (string)`

- Accessible only to registered merchants.
- Allows them to see the category under which they are registered in Pied Piper.

## Examples

Here is an example of how the smart contract functions work:

| Example | Function Call        | Sender Address | Parameter                        | Returns |
| ------- | -------------------- | -------------- | -------------------------------- | ------- |
| 1       | `grantScholarship()` | Owner          | [<Address 1>, 1000, 'meal']      | -       |
| 2       | `grantScholarship()` | Owner          | [<Address 2>, 2000, 'academics'] | -       |
| 3       | `grantScholarship()` | Owner          | [<Address 3>, 3000, 'sports']    | -       |
| 4       | `grantScholarship()` | Owner          | [<Address 4>, 4000, 'all']       | -       |
| 5       | `checkBalance()`     | Address 1      | 'meal'                           | 1000    |
| 6       | `checkBalance()`     | Address 3      | 'sports'                         | 3000    |
| 7       | `checkBalance()`     | Address 2      | 'academics'                      | 2000    |
| 8       | `checkBalance()`     | Owner          | 'all'                            | 990000  |

In this example, the owner grants scholarships to four students with different categories. Then, students check their balances in their respective categories, and the owner checks the 'all' category balance.
