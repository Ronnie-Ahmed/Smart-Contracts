// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GCDTest {

    //this function calculates the GCD (Greatest Common Divisor)
    function findgcd(uint a, uint b)internal pure returns(uint){
        uint bigNumber=(a>b)?a:b;
        uint smallNumber=(a>b)?b:a;
        uint gcd2;
        for(uint i=smallNumber;i>=1;i--){
            
            if(bigNumber%i==0 && smallNumber%i==0){
                gcd2=i;
                break;
                
            }
        }
        return gcd2;

    }
    function gcd(uint a, uint b) public pure returns (uint) {
        require(a>0 && b>0,"Transaction Failed");
        uint value=findgcd(a,b);
        return value;

    }

}