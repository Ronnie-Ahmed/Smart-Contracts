const address = "0xB34db0d5aA577998c10c80d76F87AfE58b024e5F";
const contractabi = [
  {
    inputs: [],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "from",
        type: "address",
      },
      {
        internalType: "address",
        name: "to",
        type: "address",
      },
    ],
    name: "Vote",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_delegatename",
        type: "string",
      },
      {
        internalType: "address payable",
        name: "_delegationAddress",
        type: "address",
      },
    ],
    name: "addDelegation",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "address payable",
        name: "_voteraddress",
        type: "address",
      },
    ],
    name: "addVoters",
    outputs: [],
    stateMutability: "payable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "address",
        name: "_voterAddress",
        type: "address",
      },
    ],
    name: "changeVoterInfo",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_name",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "_numberOfCandidate",
        type: "uint256",
      },
    ],
    name: "createElection",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "delegate",
    outputs: [
      {
        internalType: "string",
        name: "delegatename",
        type: "string",
      },
      {
        internalType: "address",
        name: "delegationAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "votecount",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "IsDelegated",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getResult",
    outputs: [
      {
        components: [
          {
            internalType: "string",
            name: "delegatename",
            type: "string",
          },
          {
            internalType: "address",
            name: "delegationAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "votecount",
            type: "uint256",
          },
          {
            internalType: "bool",
            name: "IsDelegated",
            type: "bool",
          },
        ],
        internalType: "struct VotingSystem.Delegate",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "name",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "voters",
    outputs: [
      {
        internalType: "address",
        name: "voteraddress",
        type: "address",
      },
      {
        internalType: "string",
        name: "name",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "id",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "numberofVotes",
        type: "uint256",
      },
      {
        internalType: "bool",
        name: "isVoted",
        type: "bool",
      },
      {
        internalType: "bool",
        name: "isVoter",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
];

module.exports = { address, contractabi };
