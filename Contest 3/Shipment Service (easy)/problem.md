# Shipment Service (Easy) - Smart Contract Documentation

A shipment service is facing challenges with tracking orders, resulting in customer satisfaction issues. To improve their operations, they are migrating their order management system to a smart contract-based blockchain solution. This transition aims to enhance transparency, efficiency, and customer experience.

## Process

1. **Smart Contract Deployment**: The warehouse manager, acting as the contract owner, deploys the smart contract.

2. **Dispatching Orders**: The contract owner utilizes the smart contract to mark an order as dispatched, initiating the shipping process via the shipping service.

3. **OTP Confirmation**: When marking an order as dispatched, the owner includes a four-digit OTP (One-Time Password), chosen from the range 999 to 10,000 (excluding numbers starting with 0).

4. **Customer OTP Notification**: The customer receives the OTP via a messaging service and must send it to the smart contract to confirm order acceptance upon delivery.

5. **Order Status Check**: Customers can check their order status using the smart contract. Possible statuses are:

   - "no orders placed" if no orders are placed.
   - "shipped" if the order is dispatched.
   - "delivered" if the last order is successfully delivered.

6. **Owner Address Exclusion**: The owner's address is not considered a customer's address within the smart contract.

7. **Order Dispatch Restriction**: Until one order is completely delivered, another order cannot be dispatched to the same address for ease of implementation.

## Smart Contract Functions

The smart contract must contain the following public functions:

### `shipWithPin(address customerAddress, uint pin) public`

- **Description**: This function is accessible only by the owner (warehouse manager) and is used to mark an order as dispatched. The owner provides the customer's address and a four-digit OTP (pin) between 999 and 10,000 to verify the order.

### `acceptOrder(uint pin) public returns ()`

- **Description**: This function can only be accessed by the customer. After receiving the shipment at their address, the customer can mark the order as accepted by entering the OTP (pin) provided to them.

### `checkStatus(address customerAddress) public returns (string)`

- **Description**: Customers can check the status of their own orders by providing their address. It returns a string indicating the status of the order. Possible status values include:
  - "no orders placed" if the customer has not placed any orders.
  - "shipped" if the order has been dispatched.
  - "delivered" if the last order has been successfully delivered.

### `totalCompletedDeliveries(address customerAddress) public returns (uint)`

- **Description**: This function enables customers to determine the number of successfully completed deliveries to their specific address. By providing their address, customers can retrieve the total count of completed deliveries. The owner can also use this function to check the number of successfully completed deliveries for any address.

## Implementation

Implement the required smart contract to facilitate the shipment service's database migration.

## Example

### Input/Output

- **Function**: `shipWithPin()`
- **Sender address**: Owner
- **Parameter**: `(<Address 1>, 1220)`
- **Returns**: N/A

- **Input/Output**

- **Function**: `acceptOrder()`
- **Sender address**: Address 1
- **Parameter**: `(1220)`
- **Returns**: N/A

- **Input/Output**

- **Function**: `checkStatus()`
- **Sender address**: Owner
- **Parameter**: `(<Address 1>)`
- **Returns**: `"delivered"`

- **Input/Output**

- **Function**: `totalCompletedDeliveries()`
- **Sender address**: Address 1
- **Parameter**: `(<Address 1>)`
- **Returns**: `1`
