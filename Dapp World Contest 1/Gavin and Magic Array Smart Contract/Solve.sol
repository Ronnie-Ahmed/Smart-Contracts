// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MagicArray {
    //this function outputs value of arr[ind] after 'hrs' number of hours
    function findValue(
        int[] memory arr,
        uint ind,
        uint hrs
    ) public pure returns (int) {
        require(ind < arr.length, "Transaction Failed");
        int value;
        for (uint256 i = 0; i < arr.length; i++) {
            if (i == ind) {
                value = arr[i];
                break;
            }
        }
        return value * int(hrs);
    }
}
