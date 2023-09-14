// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
 * @author: Ronnie Ahmed
 * @title: Triangle Inequality Smart Contract
 * @dev: Checks if a triangle is possible with sides of lengths a, b, and c
 * @github: https://github.com/Ronnie-Ahmed
 * Email : rksraisul@gmail.com
 */

contract TriangleInequality {
    // Function to check if a triangle is possible with sides of lengths a, b, and c
    function check(uint a, uint b, uint c) public pure returns (bool) {
        uint sum = a + b;
        bool isPossible = false;

        // Check if the sum of the lengths of two sides is greater than the length of the third side
        if (sum > c) {
            isPossible = true; // If true, a triangle is possible.
        }

        return isPossible; // Return the result indicating if a triangle is possible.
    }
}
