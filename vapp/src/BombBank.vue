<template>
  <div v-if="isDrizzleInitialized">
    <TxStatus
      :txIndex="txHash"
      :blockExpUrl="blockExpLink"
      v-if="txHash > -1"
    />
    <p>
      BOMB deflatory nature is great for it being <b>Store of Value</b>. But
      <b>scarcity is not enough</b>, token needs <b>usage</b> in order to have
      <b>value</b>. Needs liquidity. Here is where <b>Liquid BOMB</b> shine.
      <b>Fully backed</b> by BOMB, with 18 decimals. without penalty on
      transfer.
    </p>
    <p>
      Let's tax users that leaves ecosystem (for example by trading), not one
      that want interact with each other inside it.
    </p>
    <p>Your BOMB balance:{{ bombBalance }}</p>
    <p>Your Liquid BOMB balance:{{ liquidBombBalance }}</p>
    <p>
      <button v-if="bombAllowence === '0'" v-on:click="approveBOMB">
        Approve BOMB
      </button>

      <button v-if="bombAllowence !== '0'" v-on:click="revokeBOMB">
        Revoke approve BOMB
      </button>
      <button v-if="liquidAllowence === '0'" v-on:click="approveLiquid">
        Approve Liquid
      </button>
      <button v-if="liquidAllowence !== '0'" v-on:click="revokeLiquid">
        Revoke Approve Liquid
      </button>
    </p>
    <p><b>Total amount of Liquid Bombs:</b>{{ liquidAmount }}</p>
    <p><b>BOMB's backing up:</b>{{ bombAmount }}</p>

    <p>
      Donate BOMBs to increase Liquid Bomb value (altruistic support, no tokens
      back!)
    </p>
    <input
      type="text"
      v-model="donation"
      :disabled="bombAllowence == 0"
    /><button v-on:click="donate" :disabled="bombAllowence == 0">
      Donate
    </button>
    <p>
      Wrap BOMBs into Liquid BOMBs (you will get number od 18 decimals tokens
      proportinal to what you supplied to the Bank)
    </p>
    <input type="text" v-model="bomb" :disabled="bombAllowence == 0" /><button
      :disabled="bombAllowence == 0"
      v-on:click="wrap"
    >
      Wrap
    </button>

    <p>Transform Liquid BOMB back into rock solid BOMB</p>
    <input
      type="text"
      v-model="liquid"
      :disabled="liquidAllowence == 0"
    /><button v-on:click="unwrap" :disabled="liquidAllowence == 0">
      Unwrap
    </button>

    <p>
      <b>Ropsten</b> BOMB faucet:
      <button v-on:click="getTestBombs">Get test BOMB</button>
    </p>
  </div>

  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from "vuex";
import TxStatus from "./TxStatus";

export default {
  name: "BombBank",
  computed: {
    ...mapGetters("accounts", ["activeAccount", "activeBalance"]),
    ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
    ...mapGetters("contracts", ["contractInstances"]),

    accounts() {
      return [this.activeAccount];
    },
    liquidAllowence() {
      //liquidAllowenceKey
      var val = 0;
      try {
        val = this.contractInstances.LBombToken.allowance[
          this.liquidAllowenceKey
        ].value;
      } catch (e) {
        val = 0;
      }
      // eslint-disable-next-line
      console.log("liquid allowence", val);
      return this.drizzleInstance.web3.utils.fromWei(val.toString(), "ether");
    },
    bombAllowence() {
      //liquidAllowenceKey
      var val = 0;
      try {
        val = this.contractInstances.BOMBv3.allowance[this.bombAllowenceKey]
          .value;
      } catch (e) {
        val = 0;
      }
      // eslint-disable-next-line
      console.log("bomb allowence", val);

      return val;
    },
    liquidAmount() {
      var val = 0;
      try {
        val = this.contractInstances.LBombToken.totalSupply[this.totalSupplyKey]
          .value;
      } catch (e) {
        val = 0;
      }
      return this.drizzleInstance.web3.utils.fromWei(val.toString(), "ether");
    },
    bombAmount() {
      var val = 0;
      try {
        val = this.contractInstances.BombBank.backedBy[this.backedByKey].value;
      } catch (e) {
        val = 0;
      }

      return val.toString();
    },
    liquidBombBalanceKey: function() {
      return this.drizzleInstance.contracts.LBombToken.methods.balanceOf.cacheCall(
        this.accounts[0]
      );
    },
    bombBalanceKey: function() {
      return this.drizzleInstance.contracts.BOMBv3.methods.balanceOf.cacheCall(
        this.accounts[0]
      );
    },
    liquidBombBalance: function() {
      var val = 0;
      try {
        val = this.contractInstances.LBombToken.balanceOf[
          this.liquidBombBalanceKey
        ].value;
      } catch (e) {
        val = 0;
      }
      return this.drizzleInstance.web3.utils.fromWei(val.toString(), "ether");
    },
    bombBalance: function() {
      var val = 0;
      try {
        val = this.contractInstances.BOMBv3.balanceOf[this.bombBalanceKey]
          .value;
      } catch (e) {
        val = 0;
      }
      return val.toString();
    }
  },
  data: function() {
    return {
      txHash: -1,
      liquid: 0,
      bomb: 0,
      donation: 0,
      blockExpLink: "https://ropsten.etherscan.io/tx/",
      yourBombBalance: 0,
      totalBackingBombBalance: 0
    };
  },
  methods: {
    donate: function() {
      var methods = this.drizzleInstance.contracts["BombBank"].methods;
      // eslint-disable-next-line
      console.log("Donate ", this.donation);

      this.txHash = methods.donate.cacheSend(this.donation);
    },
    getTestBombs: function() {
      var methods = this.drizzleInstance.contracts["BombFaucet"].methods;
      this.txHash = methods.get.cacheSend();
    },
    wrap: function() {
      var methods = this.drizzleInstance.contracts["BombBank"].methods;
      this.txHash = methods.wrap.cacheSend(this.bomb);
    },
    unwrap: function() {
      var methods = this.drizzleInstance.contracts["BombBank"].methods;
      var value = this.utils.toWei(this.liquid.toString(), "ether").toString();
      this.txHash = methods.unwrap.cacheSend(value);
    },
    approveBOMB: function() {
      var methods = this.drizzleInstance.contracts["BOMBv3"].methods;
      var total = "1000000000";
      var address = this.drizzleInstance.contracts["BombBank"].address;

      this.txHash = methods.approve.cacheSend(address, total);
    },
    revokeBOMB: function() {
      var methods = this.drizzleInstance.contracts["BOMBv3"].methods;
      var total = "0";
      var address = this.drizzleInstance.contracts["BombBank"].address;

      this.txHash = methods.approve.cacheSend(address, total);
    },
    approveLiquid: function() {
      var methods = this.drizzleInstance.contracts["LBombToken"].methods;
      var total = "1000000000000000000000000";
      var address = this.drizzleInstance.contracts["BombBank"].address;

      this.txHash = methods.approve.cacheSend(address, total);
    },
    revokeLiquid: function() {
      var methods = this.drizzleInstance.contracts["LBombToken"].methods;
      var total = "0";
      var address = this.drizzleInstance.contracts["BombBank"].address;

      this.txHash = methods.approve.cacheSend(address, total);
    }
  },
  created() {
    var address = this.drizzleInstance.contracts["BombBank"].address;
    this.utils = this.drizzleInstance.web3.utils;
    this.backedByKey = this.drizzleInstance.contracts.BombBank.methods.backedBy.cacheCall();
    this.totalSupplyKey = this.drizzleInstance.contracts.LBombToken.methods.totalSupply.cacheCall();
    this.liquidAllowenceKey = this.drizzleInstance.contracts.LBombToken.methods.allowance.cacheCall(
      this.accounts[0],
      address
    );
    this.bombAllowenceKey = this.drizzleInstance.contracts.BOMBv3.methods.allowance.cacheCall(
      this.accounts[0],
      address
    );
  },
  components: {
    TxStatus
  }
};
</script>

<style>
.container {
  max-with: 500px;
}
</style>
