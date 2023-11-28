// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract TokenSale {
    uint256 private totalSupply;
    uint256 private tokenPrice;
    uint256 immutable saleDuration;
    mapping(address => bool) didBuy;
    mapping(address => uint256) tokenBalance;
    mapping(address => uint256) referalCount;

    constructor(
        uint256 _totalSupply,
        uint256 _tokenPrice,
        uint256 _saleDuration
    ) {
        totalSupply = _totalSupply;
        tokenPrice = _tokenPrice;
        saleDuration = block.timestamp + _saleDuration;
    }

    function checkTokenPrice() public view returns (uint256) {
        return tokenPrice;
    }

    function purchaseToken(address referrer) public payable {
        uint256 Price = tokenPrice;
        uint256 amount = msg.value / Price;
        if (
            didBuy[msg.sender] ||
            block.timestamp > saleDuration ||
            msg.value < Price ||
            referrer == msg.sender
        ) {
            revert();
        }
        uint256 count = referalCount[referrer] += 1;
        unchecked {
            uint256 amountTogetAsReward = checkReferrals(count, amount);
            tokenBalance[msg.sender] += amount;
            tokenBalance[referrer] += amountTogetAsReward;
            uint256 total = amount + amountTogetAsReward;
            uint256 supply = totalSupply;
            if (supply < total) {
                revert();
            }
            checkPrice(amount);
            totalSupply = supply - total;
            didBuy[msg.sender] = true;
        }
    }

    function saleTimeLeft() public view returns (uint256) {
        uint256 duration = saleDuration;
        if (block.timestamp > duration) {
            revert();
        }
        return duration - block.timestamp;
    }

    function checkTokenBalance(address buyer) public view returns (uint256) {
        return tokenBalance[buyer];
    }

    function sellTokenBack(uint256 amount) public {
        assembly {
            if gt(amount, 10000) {
                revert(0, 0)
            }

            sstore(tokenPrice.slot, 11250)
        }
        tokenBalance[msg.sender] -= amount;
    }

    function getReferralCount(address referrer) public view returns (uint256) {
        return referalCount[referrer];
    }

    function getReferralRewards(
        address referrer
    ) public view returns (uint256) {
        return tokenBalance[referrer];
    }

    function checkReferrals(
        uint256 times,
        uint256 amount
    ) internal pure returns (uint256 amountToken) {
        assembly {
            switch times
            case 1 {
                amountToken := div(mul(amount, 5), 100)
            }
            case 2 {
                amountToken := div(mul(amount, 4), 100)
            }
            case 3 {
                amountToken := div(mul(amount, 3), 100)
            }
            case 4 {
                amountToken := div(mul(amount, 2), 100)
            }
            case 5 {
                amountToken := div(amount, 100)
            }
            default {
                amountToken := 0
            }
        }
    }

    function checkPrice(uint256 amount) internal {
        uint256 _price = tokenPrice;
        if (_price == 1276281562500) {
            tokenPrice = 1340095640625;
        } else {
            unchecked {
                uint256 percentage = ((amount * 10) / totalSupply) * 10;
                uint256 increase = percentage / 2;
                uint256 price = (_price * increase) / 100;
                tokenPrice = _price + price;
            }
        }
    }
}
