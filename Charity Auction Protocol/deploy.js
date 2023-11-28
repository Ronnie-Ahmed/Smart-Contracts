const { ethers } = require("ethers");
const fs = require("fs");
const path = require("path");
require("dotenv").config({ path: path.join(__dirname, "../.env") });
const { contractabi, address, bytecode } = require("./constant.js");
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL);

const Identity = async () => {
  const signer = provider.getSigner(); // Removed array destructuring
  const contract = new ethers.Contract(
    address,
    contractabi,
    signer // Removed contract owner
  );
  // const factory = new ethers.ContractFactory(contractabi, bytecode, signer);
  // const contract = await factory.deploy(
  //   "0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8"
  // );
  // console.log("IdentityContract", contract);
  console.log("IdentityContract", contract.address);
  // const adder = await contract.ADDER;
  // console.log("adder", adder);

  // console.log("DEfault Admin role", await contract.DEFAULT_ADMIN_ROLE());
};
Identity();
