// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Abacus {
    int[] filterOfInteger;
    int sumofInteger = 0;

    function addInteger(int n) public {
        filterOfInteger.push(n);
        sumofInteger += n;
    }

    function sumOfIntegers() public view returns (int) {
        return sumofInteger;
    }
}
