require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",
  networks: {
    ephemery: {
      url: process.env.VITE_RPC_URL,
      accounts: [process.env.PRIVATE_KEY],
      chainId: 1337
    }
  }
};

