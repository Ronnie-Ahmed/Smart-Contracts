// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MyContract {
    // This function returns the area of a square
    function squareArea(uint a) public pure returns (uint) {
        require(a > 0, "Must be greater than zero");
        return a * a;
    }

    // This function returns the area of a rectangle
    function rectangleArea(uint a, uint b) public pure returns (uint) {
        require(a > 0 && b > 0, "Must be greater than zero");
        return a * b;
    }
}
