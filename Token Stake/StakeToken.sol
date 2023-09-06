// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StakeToken is ERC20 {
    constructor() ERC20("StakingToken", "STK") {
        _mint(address(this), 1000000000 * 10 ** decimals());
    }

    function getFreeToken() external {
        _transfer(address(this), msg.sender, 1000 * 10 ** decimals());
    }
}
