# Gavin and Magic Array Smart Contract

Gavin has a magical array of integers that start changing every hour since its creation. These changes follow a specific rule, where after `n` hours since creation, all the numbers in the array become `n` times the numbers at the time of creation. For example, if the array's values were `a0`, `a1`, `a2`, ... at the time of creation (i.e., at 0th hour), then after `n` hours, the array's values will be `n*a0`, `n*a1`, `n*a2`, ....

Gavin wants you to develop a smart contract that can determine the value of the `i`th integer in the array (i.e., `a[i]`) after `n` hours.

## Smart Contract Function

The smart contract must contain the following public function:

### `findValue(int[] a, uint ind, uint hrs) returns (int)`

This function returns the value of `a[ind]` after `hrs` number of hours.

## Examples

Here are some examples of how the `findValue` function works:

| Example | Function Call                       | Parameter                | Returns |
| ------- | ----------------------------------- | ------------------------ | ------- |
| 1       | `findValue([-1, 2, 3, 4, 2], 0, 5)` | `[-1, 2, 3, 4, 2], 0, 5` | -5      |
| 2       | `findValue([-1, 2, 3, 4, 2], 1, 5)` | `[-1, 2, 3, 4, 2], 1, 5` | 10      |
| 3       | `findValue([-1, 2, 3, 4, 2], 4, 3)` | `[-1, 2, 3, 4, 2], 4, 3` | 6       |

In the first example, the `findValue` function is called with an array `[-1, 2, 3, 4, 2]`, and we want to find the value at index `0` after `5` hours. The result is `-5`.

In the second example, the function is called with the same array, and we want to find the value at index `1` after `5` hours, which is `10`.

In the third example, the function is called again with the same array, and we want to find the value at index `4` after `3` hours, which is `6`.
