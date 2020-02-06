<template>
  <div v-if="isDrizzleInitialized" id="app">
    <img alt="Vue logo" src="./assets/logo.png" width="300px" />

    <div class="section">
      <h2>BOMB Bank</h2>
      <BombBank />
    </div>
  </div>
  <div v-else>Loading...</div>
</template>

<script>
import BombBank from "./BombBank";
import { mapGetters } from "vuex";

export default {
  name: "app",
  components: {
    BombBank
  },

  computed: mapGetters("drizzle", ["isDrizzleInitialized"])
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.section {
  margin: auto;
  width: 40em;
}
</style>
