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
    mapping(address => uint) totalshipped;
    mapping(address => ShipmentState) shipmateState2;
    struct OrderList {
        address customer;
        uint pin;
    }
    OrderList[] public orderList;
    mapping(address => OrderList) public maptoOderList;

    //This function inititates the shipment
    function shipWithPin(address customerAddress, uint pin) public OnlyOwner {
        require(customerAddress != owner, "Transaction Failed");
        require(pin > 999 && pin < 10000, "Transaction Failed");
        isCustomer[customerAddress] = true;
        shipmentState[customerAddress][pin] = ShipmentState.shipped;
        shipmateState2[customerAddress] = ShipmentState.shipped;
        totalshipped[customerAddress] += 1;
        orderList.push(OrderList(customerAddress, pin));
        maptoOderList[customerAddress] = OrderList(customerAddress, pin);
    }

    //This function acknowlegdes the acceptance of the delivery
    function acceptOrder(uint pin) public {
        require(
            isCustomer[msg.sender],
            "Only Customer can access this function"
        );
        bool isMatched = false;
        uint ithNumebr = 0;
        for (uint i = 0; i < orderList.length; i++) {
            if (
                orderList[i].customer == msg.sender && orderList[i].pin == pin
            ) {
                isMatched = true;
                ithNumebr = i;
            }
        }
        if (!isMatched) {
            revert();
        }
        shipmentState[msg.sender][pin] = ShipmentState.delivered;
        shipmateState2[msg.sender] = ShipmentState.delivered;
        totalCompleteDelivery[msg.sender] += 1;
        totalshipped[msg.sender] -= 1;

        OrderList storage temporder = orderList[ithNumebr];
        temporder.customer = address(0);
        temporder.pin = 0;
    }

    //This function outputs the status of the delivery
    function checkStatus(address customerAddress) public view returns (uint) {
        // require(msg.sender==customerAddress,"Transaction Fail");
        require(
            msg.sender == customerAddress || msg.sender == owner,
            "Transaction Fail"
        );

        return totalshipped[customerAddress];
    }

    //This function outputs the total number of successful deliveries
    function totalCompletedDeliveries(
        address customerAddress
    ) public view returns (uint) {
        require(
            msg.sender == customerAddress || msg.sender == owner,
            "Transaction Fail"
        );

        return totalCompleteDelivery[customerAddress];
    }
}
