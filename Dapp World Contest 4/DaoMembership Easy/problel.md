# DAO Membership - Easy

![DAO Image](dao_img)

A Decentralized Autonomous Organization (DAO) is like a digital community run by computer programs known as smart contracts on a blockchain. This makes decision-making and management decentralized and efficient.

## Overview

Now, a group of friends, Dinesh, Gavin, and Gilfoyle have decided to set up a DAO. Their goal is to create a membership system for a community that's hassle-free and secure, thanks to smart contracts. For that, they've come up with the following set of rules for the DAO membership:

1. As soon as the smart contract is deployed, the DAO gets created with 1 member in it, the owner of the smart contract.
2. Aspiring members must apply for DAO entry using the smart contract.
3. Entry requires approval from a minimum of 30% of current DAO members.
4. Only current members can access DAO information like member count and membership status.

## Smart Contract Functions

The smart contract must contain the following public functions:

### `applyForEntry() public`

- This function is accessible only to the non-members of the DAO.
- Using this function, non-members can send the request to join at max only once.
- This function is not accessible to the people who have been previously DAO members.

### `approveEntry(address applicant) public`

- This function is accessible only to the members of the DAO.
- Members can approve the applicants for the membership.
- As soon as 30% or more members approve the entry, the applicant becomes a member of the DAO.
- The address in the argument of this function should strictly correspond to someone who is eligible for DAO membership, has applied for the entry, but is not a member yet.

## Smart Contract Functions (continued)

### `isMember(address participant) public returns (bool)`

- This function is only accessible to the members of DAO.
- Using this function, a member can check by passing in the arguments whether a user corresponding to the address is a member of DAO or not.
- If the address corresponds to a member, then the function returns true; otherwise, it will return false.

### `totalMembers() public returns (uint)`

- This function is only accessible to the members of DAO.
- Using this function, a member can check the total number of current members in the DAO.

## Example Usage

```solidity
// Function: isMember()
// Sender: Owner
// Parameter: (<Owner>)
// Returns: true
```
