<template>
  <v-app :style="{ background: $vuetify.theme.themes[theme].background }">
    <SideBar />
    <v-main>
      <router-view />
    </v-main>
    <Footer />
  </v-app>
</template>

<script>
import SideBar from "./components/SideBar.vue";
import Footer from "./components/Footer.vue";

export default {
  components: { SideBar, Footer },
  name: "App",
  computed: {
    theme() {
      return this.$vuetify.theme.dark ? "dark" : "light";
    },
  },

  data: () => ({
    //
  }),
};
</script>

<style>
#app {
  background-color: var(--v-background-base);
}
</style>
