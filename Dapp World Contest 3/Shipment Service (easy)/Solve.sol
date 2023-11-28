// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ShipmentService {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Only Owner can Call This Function");
        _;
    }

    enum ShipmentState {
        no_orders_placed,
        shipped,
        delivered
    }
    mapping(address => bool) isCustomer;
    mapping(address => uint) customerPin;
    mapping(address => mapping(uint => ShipmentState)) shipmentState;
    mapping(address => uint) totalCompleteDelivery;
    mapping(address => ShipmentState) shipmateState2;
    mapping(address => bool) isDelivered;

    // This function initiates the shipment
    function shipWithPin(address customerAddress, uint pin) public OnlyOwner {
        require(customerAddress != owner, "Transaction Failed");
        require(pin > 999 && pin < 10000, "Transaction Failed");

        if (
            isCustomer[customerAddress] == true &&
            shipmateState2[customerAddress] != ShipmentState.delivered
        ) {
            revert("Transaction Failed");
        }

        customerPin[customerAddress] = pin;
        isCustomer[customerAddress] = true;
        shipmentState[customerAddress][pin] = ShipmentState.shipped;
        shipmateState2[customerAddress] = ShipmentState.shipped;
    }

    // This function acknowledges the acceptance of the delivery
    function acceptOrder(uint pin) public {
        require(
            isCustomer[msg.sender],
            "Only Customer can access this function"
        );
        require(customerPin[msg.sender] == pin, "Transaction Failed");

        shipmentState[msg.sender][pin] = ShipmentState.delivered;
        shipmateState2[msg.sender] = ShipmentState.delivered;
        totalCompleteDelivery[msg.sender] += 1;
    }

    // This function outputs the status of the delivery
    function checkStatus(
        address customerAddress
    ) public view returns (string memory) {
        require(
            msg.sender == customerAddress || msg.sender == owner,
            "Transaction Fail"
        );

        return gettingStatus(shipmateState2[customerAddress]);
    }

    // This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(
        address customerAddress
    ) public view returns (uint) {
        require(
            msg.sender == customerAddress || msg.sender == owner,
            "Transaction Fail"
        );

        return totalCompleteDelivery[customerAddress];
    }

    function gettingStatus(
        ShipmentState _status
    ) internal pure returns (string memory) {
        if (_status == ShipmentState.delivered) {
            return "delivered";
        } else if (_status == ShipmentState.shipped) {
            return "shipped";
        } else {
            return "no orders placed";
        }
    }
}
