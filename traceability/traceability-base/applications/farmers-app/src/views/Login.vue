<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="12" md="4" offset-md="4">
        <div>
          <v-alert dense outlined type="error" v-if="checkSigin">
            "message": "Invalid username/password"
          </v-alert>
        </div>

        <!-- login page -->
        <v-sheet color="white" elevation="1" rounded>
          <div class="v-lazy" style="min-height: 70px;">
            <div
              class="d-flex justify-center align-center"
              style="min-height: 70px;"
            >
              <div class="title-card">
                <strong><h2>Login</h2></strong>
              </div>
            </div>
          </div>
          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />

          <template>
            <v-container>
              <v-row>
                <v-col cols="12" sm="12" md="12">
                  <validation-observer ref="observer" v-slot="{ invalid }">
                    <form @submit.prevent="submit">
                      <!-- Actor Section ------------------------------------ -->
                      <validation-provider
                        v-slot="{ errors }"
                        name="Username"
                        rules="required"
                      >
                        <strong class="text-label">Username</strong>
                        <v-text-field
                          v-model.trim="form.username"
                          :error-messages="errors"
                          required
                          outlined
                          class="mt-2"
                          placeholder="username"
                        ></v-text-field>
                      </validation-provider>

                      <!-- Event Type Section------------------------------------ -->
                      <validation-provider
                        v-slot="{ errors }"
                        name="Password"
                        rules="required"
                      >
                        <strong class="text-label">Password</strong>
                        <v-text-field
                          v-model.trim="form.password"
                          :error-messages="errors"
                          required
                          outlined
                          class="mt-2"
                          type="password"
                          placeholder="password"
                        ></v-text-field>
                      </validation-provider>

                      <!-- Button Section ------------------------------------------>
                      <v-tooltip top>
                        <template v-slot:activator="{ on, attrs }">
                          <v-btn
                            color="primary"
                            v-bind="attrs"
                            v-on="on"
                            class="pa-6 pl-10 pr-10 mt-10"
                            type="submit"
                            :disabled="invalid"
                            :loading="loading"
                            block
                          >
                            login
                          </v-btn>
                        </template>
                        <span>insert event data</span>
                      </v-tooltip>
                    </form>
                  </validation-observer>
                </v-col>
              </v-row>
            </v-container>
          </template>
        </v-sheet>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import { required } from "vee-validate/dist/rules";
import { mapActions } from "vuex";
import {
  extend,
  ValidationObserver,
  ValidationProvider,
  setInteractionMode,
} from "vee-validate";

setInteractionMode("eager");

extend("required", {
  ...required,
  message: "{_field_} can not be empty",
});

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
  },
  data() {
    return {
      form: {
        username: "",
        password: "",
      },
      checkSigin: false,
      loading: false,
    };
  },

  methods: {
    ...mapActions({
      signIn: "auth/signIn",
    }),

    submit() {
      this.loading = true;
      this.checkSigin = false;
      //this.$refs.observer.validate();
      this.$refs.observer.validate().then(() => {
        this.signIn(this.form).then(() => {
          this.$router
            .replace({
              name: "Dashboard",
            })
            .catch(() => {
              this.checkSigin = true;
              this.loading = false;
            });
        });
      });
    },
  },
};
</script>
<style scoped>
.text-label {
  margin: 0 3px;
  /* color: rgba(0, 0, 0, 0.7); */
}
.line {
  border-bottom: solid 1px rgba(1, 1, 1, 0.1);
  margin-bottom: 1.5rem;
  margin-top: 1rem;
}
/* .text-title {
  color: rgba(0, 0, 0, 0.6);
} */
</style>
