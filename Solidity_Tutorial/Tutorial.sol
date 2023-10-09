// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
error ErrorHappen(bytes32 data, address sender);

contract Test1 {
    function testing() public pure returns (uint256) {
        return 123;
    }
}

contract Test2 {
    // Test1 public test1;
    function testing2(Test1 test) public pure returns (uint256) {
        return test.testing();
    }
}

contract ViewContract {
    bytes32 Name = "Ronnie";

    function getname(uint256 _a) public view returns (bytes32) {
        if (_a > 10) {
            revert ErrorHappen(Name, msg.sender);
        } else {
            return Name;
        }
    }
}

contract DeleteArrayValue {
    uint256[] values = [1, 2, 3, 4, 5, 6, 7];

    function remove(uint256 value) external {
        uint256[] storage tempValue = values;
        for (uint256 i = 0; i < tempValue.length; i++) {
            if (tempValue[i] == value) {
                tempValue[i] = tempValue[tempValue.length - 1];
                tempValue.pop();
                break;
            }
        }
    }

    function getValues() public view returns (uint256[] memory) {
        return values;
    }

    function removeByshifting(uint256 value) external {
        uint256[] memory tempArray = new uint256[](values.length);
        uint256 indexNumber;
        for (uint256 i = 0; i < tempArray.length; i++) {
            if (values[i] == value) {
                indexNumber = i;
            }
        }
        for (uint256 i = indexNumber; i < tempArray.length - 1; i++) {
            values[i] = values[i + 1];
        }
        values.pop();
    }
}

contract DeleteMapping {
    mapping(address => uint256) balances;
    address[] balanceAddress;
    mapping(address => bool) isAdded;

    function addBalance(uint256 balance) external {
        balances[msg.sender] += balance;
        if (!isAdded[msg.sender]) {
            balanceAddress.push(msg.sender);
        }
        isAdded[msg.sender] = true;
    }

    function deleteBalance() external {
        require(balances[msg.sender] > 0);
        delete balances[msg.sender];
        for (uint256 i = 0; i < balanceAddress.length; i++) {
            if (balanceAddress[i] == msg.sender) {
                for (uint256 j = i; j < balanceAddress.length - 1; i++) {
                    balanceAddress[i] = balanceAddress[i + 1];
                }
                balanceAddress.pop();
            }
        }
        isAdded[msg.sender] = false;
    }

    function getBalance(address _addr) public view returns (uint256) {
        return balances[_addr];
    }

    function getAllbalance() public view returns (uint256[] memory) {
        uint256[] memory tempArray = new uint256[](balanceAddress.length);
        for (uint256 i = 0; i < balanceAddress.length; i++) {
            tempArray[i] = balances[balanceAddress[i]];
        }
        return tempArray;
    }

    event deployed(address _deployedAddress);

    function deploy() external {
        DeleteArrayValue tempDelete = new DeleteArrayValue();
        emit deployed(address(tempDelete));
        ViewContract viewcontract = new ViewContract();
        emit deployed(address(viewcontract));
    }
}

// calldata can only be used for function input

contract TestDelegateCall {
    uint256 public num;
    address public sender;
    uint256 public amount;

    function setValue(uint256 _num) external payable {
        num = _num;
        sender = msg.sender;
        amount = msg.value;
    }
}

contract DefegateCall {
    uint256 public num;
    address public sender;
    uint256 public amount;

    function setValue(
        address _contract,
        uint256 _num
    ) external payable returns (bytes memory) {
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _num)
        );
        require(success);
        return data;
    }
}
