// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeToken is ERC20 {
    mapping(address => uint256) private _balances;

    constructor() ERC20("StakingToken", "STK") {
        _mint(address(this), 1000000000 * 10 ** decimals());
    }

    function getFreeToken() external {
        require(_balances[msg.sender] == 0, "You already have tokens");
        _transfer(address(this), msg.sender, 1000 * 10 ** decimals());
        _balances[msg.sender] += 1000 * 10 ** decimals();
    }
}
