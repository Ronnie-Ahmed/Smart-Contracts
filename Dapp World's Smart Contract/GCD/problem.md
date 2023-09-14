# GCD Test

Gavin, the CEO of a company, has assigned you a task to implement a smart contract that computes the greatest common divisor (GCD) of two unsigned integers. The GCD of two positive integers `a` and `b` is defined as the greatest positive integer that divides both `a` and `b` without leaving a remainder. Your solution must include a public function.

## Smart Contract Function

The smart contract must contain the following public function:

### `function gcd(uint a, uint b) returns (uint)`

- This function takes two unsigned integers, `a` and `b`, as inputs.
- It returns the GCD of `a` and `b` as an unsigned integer output.

## Example

Here are some examples of how the `gcd` function works:

| Example | Function Call | Parameter | Returns |
| ------- | ------------- | --------- | ------- |
| 1       | `gcd()`       | (2, 3)    | 1       |
| 2       | `gcd()`       | (36, 16)  | 4       |
| 3       | `gcd()`       | (56, 16)  | 8       |

In Example 1, the GCD of 2 and 3 is 1. In Example 2, the GCD of 36 and 16 is 4. In Example 3, the GCD of 56 and 16 is 8.

You can use this smart contract to efficiently compute the GCD of two unsigned integers.
