# Gavin, Jack, and Abacus Trick

Gavin wants to demonstrate an abacus trick to his friend, Jack, where he sums up integers that Jack throws at him. Jack, being a fan of smart contracts, wants to create a smart contract that allows him to input integers he gives to Gavin and verify the sum. The smart contract should take integers as input and output the sum of all the integers that have been input previously.

## Smart Contract Functions

The smart contract must include the following public functions:

### `addInteger(int n)`

- Allows Jack to input the number he has given to Gavin into the smart contract.
- The input must be an integer with the constraint -2^255 <= n < 2^255-1.

### `sumOfIntegers()`

- Returns the sum of all the integers Jack has sent as input to the `addInteger()` function.
- Jack can use this function to verify Gavin's summation.

## Example

Here are some examples of how the smart contract works:

### Example 1

| Call Sequence | Input/Output | Function          | Parameter/Returns |
| ------------- | ------------ | ----------------- | ----------------- |
| 1             | Input        | `addInteger()`    | 5                 |
| 2             | Output       | `sumOfIntegers()` | 5                 |
| 3             | Input        | `addInteger()`    | 6                 |
| 4             | Output       | `sumOfIntegers()` | 11                |
| 5             | Input        | `addInteger()`    | 3                 |
| 6             | Output       | `sumOfIntegers()` | 15                |
| 7             | Input        | `addInteger()`    | -1                |
| 8             | Output       | `sumOfIntegers()` | 14                |

In this example, Jack adds integers 5, 6, 3, and -1 to the smart contract. The `sumOfIntegers()` function correctly returns the sum of these integers.

### Example 2

| Call Sequence | Input/Output | Function          | Parameter/Returns |
| ------------- | ------------ | ----------------- | ----------------- |
| 1             | Input        | `addInteger()`    | 7                 |
| 2             | Input        | `addInteger()`    | 5                 |
| 3             | Input        | `addInteger()`    | -3                |
| 4             | Output       | `sumOfIntegers()` | 9                 |
| 5             | Input        | `addInteger()`    | -1                |
| 6             | Output       | `sumOfIntegers()` | 8                 |

In this example, Jack adds integers 7, 5, -3, and -1 to the smart contract. The `sumOfIntegers()` function correctly returns the sum of these integers.

Now, Jack can use this smart contract to verify Gavin's abacus trick.
