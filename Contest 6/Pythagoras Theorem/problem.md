# Pythagoras Theorem Smart Contract

## Overview

This smart contract checks whether it is possible to create a right-angled triangle with the given lengths of three sides. It implements the Pythagoras Theorem to determine whether a, b, and c can form the sides of a right-angled triangle, where `a`, `b`, and `c` are positive integers.

## Function

The smart contract contains the following public function:

### `check(uint a, uint b, uint c)`

This function takes three positive integers `a`, `b`, and `c` as parameters and returns `true` if it is possible to create a right-angled triangle with sides of length `a`, `b`, and `c` respectively. If it is not possible to create such a triangle, the function returns `false`.

## Examples

### Example 1

**Function:** `check()`

**Parameters:** `3, 4, 5`

**Returns:** `true`

In this example, the function returns `true` because it is possible to create a right-angled triangle with sides of length 3, 4, and 5, which satisfy the Pythagoras Theorem (3^2 + 4^2 = 5^2).

### Example 2

**Function:** `check()`

**Parameters:** `10, 10, 20`

**Returns:** `false`

In this example, the function returns `false` because it is not possible to create a right-angled triangle with sides of length 10, 10, and 20, as they do not satisfy the Pythagoras Theorem (10^2 + 10^2 ≠ 20^2).

This README provides an overview of the smart contract for checking the possibility of creating a right-angled triangle based on the lengths of its sides using the Pythagoras Theorem. You can deploy this contract and use the `check` function to verify whether given side lengths form a right-angled triangle.
