// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract LCM {
    // Function to calculate the LCM
    function gcd(uint a, uint b) internal pure returns (uint) {
        while (b != 0) {
            uint temp = b;
            b = a % b;
            a = temp;
        }
        return a;
    }

    function lcm(uint256 a, uint256 b) public pure returns (uint256) {
        require(a > 0 && b > 0, "Must be greater than Zero");
        uint256 gcdvalue = gcd(a, b);
        return (a * b) / gcdvalue;
    }
}
