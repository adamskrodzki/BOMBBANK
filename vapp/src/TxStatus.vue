<template>
  <div v-if="isDrizzleInitialized">
    <div v-if="isVisible">
      transaction
      <a v-if="txHash !== '.....'" v-bind:href="totalUrl" target="_blank">{{
        txHash
      }}</a>
      <span v-if="txHash === '.....'">....</span> in status
      {{ status }}
    </div>
  </div>
  <div v-else>Loading...</div>
</template>

<script>
import { mapGetters } from "vuex";
import _ from "lodash";

export default {
  name: "TxStatus",
  props: ["blockExpUrl", "txIndex"],
  computed: {
    ...mapGetters("drizzle", ["isDrizzleInitialized", "drizzleInstance"]),
    ...mapGetters("contracts", ["getContractData"]),
    isVisible() {
      const retVal = !this.hide && this.txIndex != -1;
      return retVal;
    },
    txHash() {
      if (!this.state || !this.state.transactionStack || this.txIndex == -1) {
        return undefined;
      }
      const txHashV = this.state.transactionStack[this.txIndex];
      if (txHashV && txHashV.startsWith("TEMP")) {
        return ".....";
      }
      return txHashV;
    },
    status() {
      if (!this.txHash) {
        return undefined;
      }
      if (this.txHash && this.txHash.startsWith("....")) {
        return "waiting confirmation";
      }
      return this.state.transactions[this.txHash].status;
    },
    totalUrl() {
      return this.blockExpUrl.replace("address", "tx") + this.txHash;
    }
  },
  watch: {
    status() {
      if (this.status == "success") {
        const that = this;
        setTimeout(() => {
          that.setHide();
        }, 3000);
      }
    },
    txIndex() {
      this.hide = false;
    }
  },
  methods: {
    setHide() {
      this.hide = true;
    }
  },
  data() {
    return {
      hide: false,
      renderId: 0,
      state: {}
    };
  },
  created() {
    const that = this;
    that._ = _;
    this.state = this.drizzleInstance.store.getState();
    const handler = this._.debounce(() => {
      // eslint-disable-next-line
      console.log("this.drizzleInstance.store.subscribe ");
      that.state = that.drizzleInstance.store.getState();
    }, 500);
    this.drizzleInstance.store.subscribe(handler);
  }
};
</script>

<style></style>
