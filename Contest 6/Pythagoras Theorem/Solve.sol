// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RightAngledTriangle {
    // To check if a triangle with side lengths a, b, c is a right-angled triangle
    function check(uint a, uint b, uint c) public pure returns (bool) {
        // Ensure none of the sides are zero
        if (a == 0 || b == 0 || c == 0) {
            return false;
        }

        // Calculate squares of sides
        uint aSquared = a * a;
        uint bSquared = b * b;
        uint cSquared = c * c;

        // Check Pythagorean theorem
        return (aSquared + bSquared == cSquared) ||
               (aSquared + cSquared == bSquared) ||
               (bSquared + cSquared == aSquared);
    }
}
