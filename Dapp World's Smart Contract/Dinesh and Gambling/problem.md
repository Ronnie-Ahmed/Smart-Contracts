# Dinesh and Gambling - Finding the Second Largest Integer

Dinesh is participating in a gambling game where he needs to guess the second largest integer chosen by a website from an array of integers. He wants to implement a Solidity function to quickly find the second largest integer in the array to improve his chances of winning the game.

## Smart Contract Function

The smart contract must contain the following public function:

### `findSecondLargest(int[] arr) returns (int)`

- This function returns the second largest unique integer in the array.
- `arr` is an array of integers where 2 <= `arr.length` <= 10^4 and -2^255 <= `arr[i]` <= 2^255 - 1.
- It is guaranteed that no two integers in the array are the same.

## Examples

Here are some examples of how the `findSecondLargest` function works:

| Example | Function Call         | Parameter     | Returns |
| ------- | --------------------- | ------------- | ------- |
| 1       | `findSecondLargest()` | [1, 2, 3, 4]  | 3       |
| 2       | `findSecondLargest()` | [-5, 8, 1, 7] | 7       |

In the first example, the function is called with an array `[1, 2, 3, 4]`, and it returns `3` as the second largest unique integer in the array.

In the second example, the function is called with an array `[-5, 8, 1, 7]`, and it returns `7` as the second largest unique integer in the array.

The function helps Dinesh quickly determine the second largest integer from the given array, improving his chances of winning the gambling game.
