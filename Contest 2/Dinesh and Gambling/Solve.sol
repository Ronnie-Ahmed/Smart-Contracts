// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SecondLargest {
    //this function outputs the second largest integer in the array
    function findSecondLargest(int[] memory arr) public pure returns (int) {
        require(arr.length >= 2, "Transaction Failed");
        int highest = (arr[0] > arr[1]) ? arr[0] : arr[1];
        int secondhighest = (arr[0] > arr[1]) ? arr[1] : arr[0];
        for (uint i = 0; i < arr.length; i++) {
            if (highest < arr[i]) {
                secondhighest = highest;
                highest = arr[i];
            } else if (arr[i] > secondhighest && arr[i] != highest) {
                secondhighest = arr[i];
            }
        }
        return secondhighest;
    }
}
