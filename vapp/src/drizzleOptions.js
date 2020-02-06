import BombBank from "./contracts/BombBank.json";
import BOMBv3 from "./contracts/BOMBv3.json";
import LBombToken from "./contracts/LBombToken.json";
import BombFaucet from "./contracts/BombFaucet.json";

const options = {
  web3: {
    block: false,
    fallback: {
      type: "ws",
      url: "ws://127.0.0.1:9545"
    }
  },
  contracts: [BombBank, BOMBv3, LBombToken, BombFaucet],
  syncAlways: true,
  events: {
    SimpleStorage: ["Donated"]
  },
  polls: {
    accounts: 15000
  }
};

export default options;
