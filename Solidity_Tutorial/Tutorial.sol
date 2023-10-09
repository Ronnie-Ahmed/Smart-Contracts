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

library Arraylib {
    function findValue(
        uint256[] storage arrayValues,
        uint256 _value
    ) internal view returns (uint256) {
        for (uint56 i = 0; i < arrayValues.length; i++) {
            if (arrayValues[i] == _value) {
                return i;
            }
        }
        revert("Not Found");
    }
}

contract TestArray {
    using Arraylib for uint256[];
    uint256[] arr = [1, 2, 3, 4, 5, 6, 7];

    function findValue(uint256 _value) public view returns (uint256) {
        return Arraylib.findValue(arr, _value);
    }
}

contract HashFunction {
    function keccakhash(
        string memory text1,
        uint256 _num,
        string memory text2
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text1, _num, text2));
    }

    function encode(
        string memory text1,
        string memory text2
    ) external pure returns (bytes memory) {
        return abi.encode(text1, text2);
    }

    function encodePacked(
        string memory text1,
        string memory text2
    ) external pure returns (bytes memory) {
        return abi.encodePacked(text1, text2);
    }

    function hashCollision(
        string memory text1,
        string memory text2
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text1, text2));
        //input AA,BB then AAA,BB then AA,BBB (Hash for last Two will be same);
    }

    function avoidCollision(
        string memory text1,
        string memory text2
    ) external pure returns (bytes32) {
        return keccak256(abi.encode(text1, text2));
    }
}

contract Verify {
    function verify(
        address _signer,
        string memory _message,
        bytes memory _sig
    ) external pure returns (bool) {
        bytes32 hashMessage = messageHash(_message);
        bytes32 hashSig = getEthSignedHash(hashMessage);
        return recoverSig(hashSig, _sig) == _signer;
    }

    function messageHash(string memory _message) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(_message));
    }

    function getEthSignedHash(bytes32 _hash) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
            );
    }

    function recoverSig(
        bytes32 _ethSignedMessageHash,
        bytes memory _signature
    ) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(
        bytes memory sig
    ) internal pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature

            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature

            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }
    /* Signature Verification

How to Sign and Verify
# Signing
1. Create message to sign
2. Hash the message
3. Sign the hash (off chain, keep your private key secret)

# Verify
1. Recreate hash from the original message
2. Recover signer from signature and hash
3. Compare recovered signer to claimed signer



ethereum.enable()
account="0x..."
hash=" " messageHash
ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)
will return bytes memory _sig
     
*/
}
