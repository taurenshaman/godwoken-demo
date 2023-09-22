import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: {
    version: "0.8.21",
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 10000,
      }
    },
  },
  networks: {
    hardhat: {
    },
    testnet: {
      url: "https://v1.testnet.godwoken.io/rpc",
      accounts: [""],
      chainId: 71401,
      gas: 50000000,
      allowUnlimitedContractSize: true,
    },
    mainnet: {
      url: "https://v1.mainnet.godwoken.io/rpc",
      accounts: [""],
      chainId: 71402,
      gas: 50000000,
      allowUnlimitedContractSize: true,
    }
  },
};

export default config;
