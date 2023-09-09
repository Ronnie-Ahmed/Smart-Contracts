# Triangle Inequality Checker

The Triangle Inequality Theorem states that the sum of any two sides of a triangle must be greater than the third side. This smart contract helps determine whether it is possible to construct a triangle with a set of three numerical values.

## Smart Contract Function

The smart contract must contain the following public function:

### `check(uint a, uint b, uint c) returns (bool)`

- This function returns `true` if it is possible to construct a triangle with sides of length `a`, `b`, and `c`.
- If it's not possible to construct a triangle with these side lengths, the function returns `false`.

## Examples

Here is an example of how the `check` function works:

| Example | Function Call | Parameter  | Returns |
| ------- | ------------- | ---------- | ------- |
| 1       | `check()`     | (7, 5, 10) | true    |
| 2       | `check()`     | (1, 1, 6)  | false   |

In the first example, the function is called with side lengths `(7, 5, 10)`, and it returns `true` because it's possible to construct a triangle with these side lengths according to the Triangle Inequality Theorem.

In the second example, the function is called with side lengths `(1, 1, 6)`, and it returns `false` because it's not possible to construct a triangle with these side lengths as they violate the Triangle Inequality Theorem.

The smart contract makes it easy to determine whether a set of three numerical values can form a valid triangle.
