# Bus Ticket Management Smart Contract

## Overview

This smart contract is designed to manage the booking of bus tickets for a travel agency. It ensures a hassle-free and open booking process, with specific rules and limitations. This version of the smart contract is implemented for testing purposes.

## Rules

The following rules govern the bus ticket booking system:

1. There are initially 20 seats available, numbered from 1 to 20.
2. At most 4 tickets can be booked from a single address.

## Functions

The smart contract contains the following public functions:

### `bookSeats(uint[] seatNumbers)`

This function takes an array of seat numbers as input. The array must not be empty, and its length cannot exceed 4. If the array contains seat numbers that are not available or if it contains duplicates, the function reverts.

### `showAvailableSeats()`

This function returns an array of all the seat numbers that are currently available for booking. The order of the seat numbers in the array can be arbitrary.

### `checkAvailability(uint seatNumber)`

Using this function, the availability of a specific seat can be checked. If the seat corresponding to `seatNumber` is available, the function returns `true`. Otherwise, it returns `false`.

### `myTickets()`

This function returns an array consisting of all the seat numbers booked by the address that triggers this function. In case there are no seats booked, an empty array will be returned.

## Examples

### Example 1

**Input:**

- **Function:** `myTickets()`
- **Sender address:** Owner

**Parameter:** `()`

**Returns:** `[]`

In this example, the owner has not booked any tickets, so the function returns an empty array.

**Input:**

- **Function:** `bookSeats()`
- **Sender address:** Owner
- **Parameter:** `([1, 2, 3, 4])`

**Output:**

- **Function:** `myTickets()`
- **Sender address:** Owner
- **Returns:** `[1, 2, 3, 4]`

The owner has booked seats 1, 2, 3, and 4. The `myTickets` function correctly returns these seat numbers.

**Output:**

- **Function:** `myTickets()`
- **Sender address:** Address 1
- **Returns:** `[]`

Address 1 has not booked any tickets, so the function returns an empty array.

**Input:**

- **Function:** `bookSeats()`
- **Sender address:** Address 1
- **Parameter:** `([3, 4])`

**Output:**

- **Function:** `myTickets()`
- **Sender address:** Owner
- **Returns:** `[1, 2, 3, 4]`

Address 1 attempted to book seats 3 and 4, but the transaction fails because it exceeds the limit of 4 tickets per address. However, the owner's previously booked tickets are still valid and displayed correctly.

This README provides an overview of the smart contract for managing bus ticket bookings, including its rules, functions, and example usage scenarios. You can deploy this contract and interact with it to test the bus ticket booking process.
