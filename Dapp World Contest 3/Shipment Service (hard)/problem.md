# Shipment Service (Hard) - Smart Contract Documentation

A shipment service is encountering difficulties in tracking orders, leading to customer issues. To enhance their operations, they are transitioning their order management system to a smart contract-based blockchain solution. This transition aims to improve transparency, efficiency, and order management.

## Process

1. **Smart Contract Deployment**: The warehouse manager deploys the smart contract, becoming the contract owner.

2. **Order Dispatch**: The contract owner uses the smart contract to mark an order as dispatched and initiate the shipping process through the shipping service.

3. **OTP for Dispatch**: When marking an order as dispatched, the owner also enters a four-digit OTP (One-Time Password) between 999 and 10,000 (excluding those starting with 0).

4. **Customer OTP Confirmation**: The customer receives the OTP through a messaging service and must send it to the smart contract to confirm order acceptance upon delivery.

5. **Order Status Check**: Customers can check the status of their orders, specifically the number of orders that have been shipped but have not yet been delivered.

6. **Owner's Address Exclusion**: The owner's address is not considered a customer's address within the smart contract.

7. **Multiple Orders to Same Address**: Multiple orders can be shipped to the same address without the necessity of the current order being successfully delivered. Multiple orders can have the same OTP (PIN) for a customer.

## Smart Contract Functions

The smart contract must include the following public functions:

### `shipWithPin(address customerAddress, uint pin) public`

- **Description**: This function can only be accessed by the owner (warehouse manager) and is used to mark an order as dispatched. The owner provides the customer's address and a four-digit OTP (PIN) between 999 and 10,000 to verify the order.

### `acceptOrder(uint pin) public returns ()`

- **Description**: This function can only be accessed by the customer. After receiving the shipment at their address, the customer can mark the order as accepted by entering the OTP (PIN) provided to them.

### `checkStatus(address customerAddress) public returns (uint)`

- **Description**: This function can only be accessed by the customer. It returns the number of orders that are on the way to the customer with the specified 'customerAddress,' meaning orders that have been shipped from the warehouse but haven't been received by the customer yet.

### `totalCompletedDeliveries(address customerAddress) public returns (uint)`

- **Description**: This function enables customers to determine the number of successfully completed deliveries to their specific address. By providing their address, customers can retrieve the total count of completed deliveries. The owner can also use this function to check the number of successfully completed deliveries for any address.

## Implementation

Implement the necessary smart contract to assist the shipment service in migrating its database.

## Example

### Input/Output

- **Function**: `shipWithPin()`
- **Sender address**: Owner
- **Parameter**: `(<Address 1>, 1220)`
- **Returns**: N/A

- **Function**: `acceptOrder()`
- **Sender address**: Address 1
- **Parameter**: `(1220)`
- **Returns**: N/A

- **Function**: `checkStatus()`
- **Sender address**: Owner
- **Parameter**: `(<Address 1>)`
- **Returns**: `0`

- **Function**: `totalCompletedDeliveries()`
- **Sender address**: Address 1
- **Parameter**: `(<Address 1>)`
- **Returns**: `1`
