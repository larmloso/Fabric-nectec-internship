<template>
  <nav>
    <v-app-bar
      app
      height="70px"
      elevation="1"
      color="white"
      class="appbar-hidden"
    >
      <v-container class="d-flex justify-space-between">
        <div>
          <v-row>
            <v-col>
              <v-btn icon @click="drawer = !drawer">
                <v-icon>mdi-menu</v-icon>
              </v-btn>
            </v-col>
          </v-row>
        </div>
        <div class="center"></div>
        <div class="end">
          <v-row>
            <v-col>
              <v-btn
                v-show="user"
                icon
                :to="{
                  name: 'NewProduct',
                  params: { ref: this.basket() },
                }"
              >
                <v-badge
                  color="red"
                  :content="this.basket().length"
                  overlap
                  v-if="this.basket() != null"
                >
                  <v-icon v-if="user">mdi-cart-variant</v-icon>
                </v-badge>
              </v-btn>
              <v-btn icon v-if="user">
                <v-icon>mdi-account-outline</v-icon>
              </v-btn>
              <span v-if="user">{{ user.givenName }}</span>
            </v-col>
            <v-col hidden>
              <v-btn icon @click="$vuetify.theme.dark = !$vuetify.theme.dark">
                <v-icon v-if="$vuetify.theme.dark">mdi-weather-sunny</v-icon>
                <v-icon v-if="!$vuetify.theme.dark"
                  >mdi-moon-waning-crescent</v-icon
                >
              </v-btn>
            </v-col>
          </v-row>
        </div>
      </v-container>
    </v-app-bar>

    <v-navigation-drawer
      v-model="drawer"
      app
      mini-variant
      mini-variant-width="200"
      v-if="authenticated"
      color="#031b4d"
      dark
    >
      <v-list>
        <v-list-item-group color="cyan">
          <v-list-item to="/">
            <v-list-item-content align="center">
              <v-icon align="center" x-large>mdi-monitor-dashboard</v-icon>
              <v-col class="logo mt-3">
                <div>
                  <h3>CLIENT&nbsp;APP&nbsp;LOGO</h3>
                </div>
              </v-col>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
        <v-divider></v-divider>
        <v-list-item-group
          v-model="selectedItem"
          color="cyan"
          v-if="authenticated"
        >
          <v-list-item v-for="(item, i) in items" :key="i" :to="item.topath">
            <v-list-item-content align="center">
              <v-icon v-text="item.icon" class="mb-3" align="center"></v-icon>
              <v-list-item-subtitle
                v-text="item.text"
                align="center"
                class="caption"
              ></v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>

        <v-list-item-group v-if="!authenticated">
          <v-list-item to="/login">
            <v-list-item-content align="center">
              <v-icon class="mb-3" align="center">mdi-login-variant</v-icon>
              <v-list-item-subtitle align="center" class="caption"
                >LOGIN</v-list-item-subtitle
              >
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>

        <v-list-item-group v-if="authenticated">
          <v-list-item @click.prevent="signOut">
            <v-list-item-content align="center">
              <v-icon class="mb-3" align="center">mdi-logout</v-icon>
              <v-list-item-subtitle align="center" class="caption"
                >LOGOUT</v-list-item-subtitle
              >
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
    </v-navigation-drawer>
  </nav>
</template>
<script>
import { mapGetters, mapActions } from "vuex";
export default {
  data: () => ({
    drawer: null,
    selectedItem: 0,
    checkthem: true,
    items: [
      {
        text: "DASHBOARD",
        icon: "mdi-tablet-dashboard",
        topath: "/dashboard",
      },
      // {
      //   text: "INSERT",
      //   icon: "mdi-file-document-edit-outline",
      //   topath: "/insert",
      // },
      { text: "SCANQRCODE", icon: "mdi-qrcode-scan", topath: "/scanqrcode" },
      // { text: "USER PROFILE", icon: "fas fa-user", topath: "/profile" },
    ],
    title: "hello",
    hidden: false,
  }),
  computed: {
    ...mapGetters({
      authenticated: "auth/authenticated",
      user: "auth/user",
    }),
  },
  /// ...map{ functionname: dir/path }
  methods: {
    ...mapActions({
      signOutAction: "auth/signOut",
    }),

    ...mapGetters({
      basket: "auth/basket",
    }),

    signOut() {
      this.signOutAction().then(() => {
        this.$router.replace({
          name: "Login",
        });
      });
    },
  },
};
</script>
<style scoped>
.logo {
  align-items: center;
  display: flex;
  flex: 1 0 auto;
  justify-content: inherit;
  line-height: normal;
  position: relative;
  transition: inherit;
}

.v-application .elevation-1 {
  box-shadow: 0px 2px 1px -1px rgb(0 0 0 / 3%), 0px 1px 1px 0px rgb(0 0 0 / 3%),
    0px 1px 3px 0px rgb(0 0 0 / 3%) !important;
}
.appbar-hidden {
  display: hidden !important;
  color: red;
}
</style>
