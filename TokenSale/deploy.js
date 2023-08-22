const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "../.env") });
const { contractabi, address } = require("./constant.js");
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL);

const TokenSale = async () => {
  const signer = provider.getSigner();
  const contract = new ethers.Contract(address, contractabi, signer);
  console.log("TokenSale", contract);
};
TokenSale();
