// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract CyberToken is ERC20 {
  
    constructor() ERC20("Cyber Token", "Cyber") {
        _mint(address(this), 10000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
    
}
contract MarginToken is ERC20 {
    
    constructor() ERC20("Margin Token", "Margin") {
          _mint(address(this), 10000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
   
}

contract AttackToken is ERC20 {
   
    constructor() ERC20("Attack Token", "AOT") {
          _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
   
}
contract TitanToken is ERC20 {
    
    constructor() ERC20("Titan Token", "TTK") {
         _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
    
}
contract HeroToken is ERC20 {
   
    constructor() ERC20("Hero Token", "HETK") {
         _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
    
}

contract MinusToken is ERC20 {
   
    constructor() ERC20("Minus Token", "MITK") {
         _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
    
}
contract VillaToken is ERC20 {
   
    constructor() ERC20("Villa Token", "VITK") {
          _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
   
}

contract GymToken is ERC20 {
   
    constructor() ERC20("Gym Token", "ZmTK") {
         _mint(address(this), 1000000*10**decimals());
    }
    function tra()external{
        _transfer(address(this), msg.sender, 1000*10**decimals());

    }
    
}