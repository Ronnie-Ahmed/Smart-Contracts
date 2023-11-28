// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Token_offering is ERC20, Ownable, ReentrancyGuard {
    error Token__TransferFailed();
    error Token__AmountMustBeBiggerThanZero();
    error Token__SendRightAmountOfETH();
    error Token__YouHaveLessToken();
    error Token__NotTheRightAddress();
    error Token__DoNotHaveEnoughToken();
    error Token__OwnerCanNotBuyToken();

    constructor() ERC20("This Contract Token", "TCK") {
        _mint(owner(), 100000 * 10 ** decimals());
    }

    uint256 private immutable _tokenPrice = 1e18;

    mapping(address => uint256) public balances;

    function getToken(uint256 amount) external payable nonReentrant {
        uint256 price = amount * _tokenPrice;
        if (msg.sender == owner()) {
            revert Token__OwnerCanNotBuyToken();
        }
        if (msg.value != price) {
            revert Token__SendRightAmountOfETH();
        }
        if (msg.sender == address(0)) {
            revert Token__NotTheRightAddress();
        }
        balances[owner()] += msg.value;
        _transfer(owner(), msg.sender, amount);
    }

    function redeemToken(uint256 amount) external nonReentrant {
        uint256 tokenamount = balanceOf(msg.sender);
        if (tokenamount < amount) {
            revert Token__DoNotHaveEnoughToken();
        }
        uint256 price = _tokenPrice * tokenamount;
        balances[owner()] -= price;
        payable(msg.sender).transfer(price);
        _transfer(msg.sender, owner(), amount);
    }

    function getBalance() external view returns (uint256) {
        return balances[owner()];
    }
}
