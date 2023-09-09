// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TriangleInequality {
    //To check if a triangle is possible with lengths a,b and c
    function check(uint a, uint b, uint c) public pure returns (bool) {
        uint sum = a + b;
        bool isPossible = false;
        if (sum > c) {
            isPossible = true;
        }
        return isPossible;
    }
}
