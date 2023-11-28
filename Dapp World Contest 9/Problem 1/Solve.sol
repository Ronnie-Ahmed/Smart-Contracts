// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract leastPrimeDifference {
    function isPrime(uint256 number) internal pure returns (bool) {
        if (number <= 1) return false;
        if (number <= 3) return true;

        if (number % 2 == 0 || number % 3 == 0) return false;

        for (uint256 i = 5; i * i <= number; i += 6) {
            if (number % i == 0 || number % (i + 2) == 0) return false;
        }

        return true;
    }

    function closestPrime(uint256 n) internal pure returns (uint256) {
        if (n <= 1) return 2; // Handle edge case

        uint256 lower = n;
        uint256 upper = n;

        while (!isPrime(lower) && !isPrime(upper)) {
            lower--;
            upper++;
        }

        return isPrime(lower) ? lower : upper;
    }

    function primeDifference(uint256 n) public pure returns (uint256) {
        uint256 closest = closestPrime(n);
        return closest > n ? closest - n : n - closest;
    }
}
