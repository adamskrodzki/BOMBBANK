const path = require("path");
var HDWalletProvider = require("truffle-hdwallet-provider");
var MNEMONIC =
  "neutral dice bone inherit coral humor april unknown expand secret bike leaf";
module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  contracts_build_directory: path.join(__dirname, "vapp/src/contracts"),
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(
          MNEMONIC,
          "https://ropsten.infura.io/v3/770b57737fc2496f8dc603dd6b26c4ad"
        );
      },
      network_id: 3,
      gas: 4000000,
      skipDryRun: true
    },
    main: {}
  }
};
