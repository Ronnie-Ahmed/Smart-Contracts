// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TokenSale {
    uint256 public  totalSupply;
    uint256 public immutable tokenPrice;
    uint256 public immutable saleDuration;
    mapping(address=>bool) didBuy;
    mapping(address=>uint256) tokenBalance;
    uint256 count;
    
    constructor(
        uint256 _totalSupply,
        uint256 _tokenPrice,
        uint256 _saleDuration
    ) {
        totalSupply=_totalSupply;
        tokenPrice=_tokenPrice;
        saleDuration=block.timestamp + _saleDuration;
    }

    function checkTokenPrice() public pure returns (uint256) {
        return  1;
    }

    function purchaseToken() public payable {
        uint256 Price=tokenPrice;
        uint256 amount=msg.value / Price;
        if(didBuy[msg.sender] || block.timestamp>saleDuration || msg.value<Price|| amount>totalSupply){
            revert();
        }
        didBuy[msg.sender]=true;
        totalSupply=totalSupply-amount;
        tokenBalance[msg.sender]+=amount;

    }

    function checkTokenBalance(address buyer) public view returns (uint256) {
        return tokenBalance[buyer];
    }

    function saleTimeLeft() public view returns (uint256) {
         if(block.timestamp>saleDuration){
            revert();
        }
        return saleDuration-block.timestamp;
    }

    function sellTokenBack(uint256 amount) public {
        
        uint256 _amount= tokenBalance[msg.sender]-=amount;
        if(_amount<400){
            revert();
        }
    }
 
}
