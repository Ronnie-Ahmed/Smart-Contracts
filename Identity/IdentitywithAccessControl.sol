// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/AccessControl.sol";

contract IdentitywithAccessControl is AccessControl {
    bytes32 public constant ADDER = keccak256("ADDER");
    bytes32 public constant CHANGER = keccak256("CHANGER");
    uint256 private id = 19104000;

    uint256 private addingfee = 0.01 ether;
    struct People {
        string name;
        string fathername;
        string mothername;
        uint256 birthyear;
        uint256 month;
        uint256 day;
        address regAddress;
        bool isListed;
    }

    constructor() {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    mapping(uint256 => People) private peoples;
    mapping(address => uint256) private addressToId;

    function changefee(uint256 _addingfee) public onlyRole(DEFAULT_ADMIN_ROLE) {
        addingfee = _addingfee;
    }

    function addPeople(
        string memory _name,
        string memory _fathername,
        string memory _mothername,
        uint256 _birthyear,
        uint256 _month,
        uint256 _day,
        address _regAddress
    ) external payable onlyRole(ADDER) returns (uint256) {
        require(msg.value >= addingfee, "Didn't send enough value");
        require(_birthyear >= 1 && _birthyear <= 2023, "Input Year data");
        require(_month <= 12 && _month >= 1, "Input Error Month");
        require(_day >= 1 && _day <= 31, "INput your right Date");
        if (
            _birthyear % 4 == 0 &&
            (_birthyear % 100 != 0 || _birthyear % 400 == 0)
        ) {
            if (_month == 2) {
                require(_day >= 1 && _day <= 29, "Input Error Day");
            } else if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 30, "Input Error Day");
            } else {
                require(_day >= 1 && _day <= 31, "Input Error day");
            }
        } else if (_month > 0 && _month < 8) {
            if (_month == 2) {
                require(_day >= 1 && _day <= 28, "Input error Day");
            } else if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 31, "Input day error");
            } else if (_month != 2) {
                require(_day >= 1 && _day <= 30, "INput error Day");
            }
        } else if (_month > 7 && _month <= 12) {
            if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 31, "Input day error");
            } else {
                require(_day >= 1 && _day <= 30, "Input day error");
            }
        }

        for (uint i = 19104000; i <= id; i++) {
            People memory people = peoples[i];
            require(people.regAddress != _regAddress, "Address Already Taken");
        }

        id++;

        peoples[id] = People(
            _name,
            _fathername,
            _mothername,
            _birthyear,
            _month,
            _day,
            _regAddress,
            true
        );
        addressToId[_regAddress] = id;
        return id;
    }

    function latestId() public view returns (People memory) {
        People memory people = peoples[id];
        return people;
    }

    function addADDER(address adder) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(ADDER, adder);
    }

    function revokeADDER(address adder) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(ADDER, adder);
    }

    function addChanger(address changer) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(CHANGER, changer);
    }

    function revokeChanger(
        address changer
    ) external onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(CHANGER, changer);
    }

    function myId(uint256 ID) public view returns (People memory) {
        require(ID > 19104000 && ID <= id, "Id do not exist");
        People memory people = peoples[ID];
        return people;
    }

    function myIdnumber(address myaddress) external view returns (uint256) {
        return addressToId[myaddress];
    }

    function changeIdvalue(
        uint256 ID,
        string memory _name,
        string memory _fathername,
        string memory _mothername,
        uint256 _birthyear,
        uint256 _month,
        uint256 _day,
        address _regAddress
    ) external payable onlyRole(CHANGER) {
        require(msg.value >= addingfee, "Didn't send enough value");
        require(_birthyear >= 1 && _birthyear <= 2023, "Input Year data");
        require(_month <= 12 && _month >= 1, "Input Error Month");
        require(_day >= 1 && _day <= 31, "INput your right Date");
        if (
            _birthyear % 4 == 0 &&
            (_birthyear % 100 != 0 || _birthyear % 400 == 0)
        ) {
            if (_month == 2) {
                require(_day >= 1 && _day <= 29, "Input Error Day");
            } else if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 30, "Input Error Day");
            } else {
                require(_day >= 1 && _day <= 31, "Input Error day");
            }
        } else if (_month > 0 && _month < 8) {
            if (_month == 2) {
                require(_day >= 1 && _day <= 28, "Input error Day");
            } else if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 31, "Input day error");
            } else if (_month != 2) {
                require(_day >= 1 && _day <= 30, "INput error Day");
            }
        } else if (_month > 7 && _month <= 12) {
            if (_month % 2 == 0) {
                require(_day >= 1 && _day <= 31, "Input day error");
            } else {
                require(_day >= 1 && _day <= 30, "Input day error");
            }
        }
        require(ID > 19104000 && ID <= id, "Id do not exist");
        People storage people = peoples[ID];
        people.name = _name;
        people.fathername = _fathername;
        people.mothername = _mothername;
        people.birthyear = _birthyear;
        people.month = _month;
        people.day = _day;
        people.regAddress = _regAddress;
    }
}
