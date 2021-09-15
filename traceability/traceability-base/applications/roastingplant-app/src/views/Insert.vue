<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="12" md="7" offset-md="2">
        <v-sheet color="white" elevation="1" rounded>
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center">
                <strong class="text-type">Create Product</strong>
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
              <validation-observer ref="observer" v-slot="{ invalid }">
                <form @submit.prevent="submit" class="mt-2">
                  <!-- Actor Section ------------------------------------ -->
                  <validation-provider
                    v-slot="{ errors }"
                    name="Type"
                    rules="required"
                  >
                    <strong class="text-label">Type</strong>
                    <v-text-field
                      v-model.trim="type"
                      :error-messages="errors"
                      required
                      outlined
                      class="mt-2"
                      placeholder="Pruduct type string"
                    ></v-text-field>
                  </validation-provider>

                  <v-row>
                    <v-col cols="12" sm="12" md="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="amount"
                        rules="required"
                      >
                        <strong class="text-label">Amount</strong>
                        <v-text-field
                          v-model.trim="amount"
                          :error-messages="errors"
                          required
                          outlined
                          class="mt-2"
                          placeholder="amount number"
                          type="number"
                        ></v-text-field>
                      </validation-provider>
                    </v-col>
                    <v-col cols="12" sm="12" md="6">
                      <validation-provider
                        v-slot="{ errors }"
                        name="datetime"
                        rules="required"
                      >
                        <strong class="text-label">Date time</strong>
                        <v-menu
                          ref="menu"
                          v-model="menu"
                          :close-on-content-click="false"
                          :return-value.sync="date"
                          transition="scale-transition"
                          offset-y
                          min-width="auto"
                        >
                          <template v-slot:activator="{ on, attrs }">
                            <v-text-field
                              v-model="date"
                              prepend-inner-icon="mdi-calendar"
                              readonly
                              v-bind="attrs"
                              v-on="on"
                              outlined
                              :error-messages="errors"
                              required
                              class="mt-2"
                            ></v-text-field>
                          </template>
                          <v-date-picker v-model="date" no-title scrollable>
                            <v-spacer></v-spacer>
                            <v-btn text color="primary" @click="menu = false">
                              Cancel
                            </v-btn>
                            <v-btn
                              text
                              color="primary"
                              @click="$refs.menu.save(date)"
                            >
                              OK
                            </v-btn>
                          </v-date-picker>
                        </v-menu>
                      </validation-provider>
                    </v-col>
                  </v-row>

                  <!-- Log level Section ------------------------------------------>
                  <validation-provider>
                    <strong class="text-label">Note</strong>
                    <v-textarea
                      v-model.trim="note"
                      outlined
                      rows="3"
                      placeholder="note"
                      dense
                    ></v-textarea>
                  </validation-provider>

                  <!-- Button Section ------------------------------------------>

                  <v-tooltip top>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        color="primary"
                        v-bind="attrs"
                        v-on="on"
                        class="mr-4 pa-6 pl-10 pr-10"
                        type="submit"
                        :disabled="invalid"
                        :loading="loading"
                        :block="$vuetify.breakpoint.mobile"
                      >
                        submit
                      </v-btn>
                    </template>
                    <strong>insert event data</strong>
                  </v-tooltip>
                </form>
              </validation-observer>
            </v-container>
          </template>
        </v-sheet>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import { required } from "vee-validate/dist/rules";
import {
  extend,
  ValidationObserver,
  ValidationProvider,
  setInteractionMode,
} from "vee-validate";
// import axios from 'axios';
import { mapGetters, mapActions } from "vuex";

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
      type: "",
      amount: "",
      note: "",
      dataObj: "",
      loading: false,
      checkInsert: false,
      date: new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10),
      menu: false,
      time: new Date(new Date().getTime()).toLocaleTimeString("en-GB"),
      datetime: "",
    };
  },

  computed: {
    ...mapGetters({
      user: "auth/user",
    }),
  },

  methods: {
    ...mapActions({
      inSert: "eventData/inSert",
    }),
    submit() {
      this.loading = true;
      this.checkInsert = false;
      this.datetime = `${this.date} ${this.time}`;

      this.$refs.observer.validate().then(() => {
        this.dataObj = {
          type: this.type,
          amount: Number(this.amount),
          datetime: String(new Date(this.datetime).getTime()),
          note: this.note,
          user: this.user.givenName,
        };
        this.inSert(this.dataObj).then(() => {
          this.loading = false;
          this.checkInsert = true;
          this.$router.push({ path: "/dashboard" });
        });
      });
    },
    AddField: function() {
      this.formEventData.push({ title: "", details: "" });
      console.log(this.formEventData);
    },
    DeleteField: function(idx) {
      if (idx > -1) {
        this.formEventData.splice(idx, 1);
      }
    },
    clear() {
      this.type = "";
      this.amount = "";
      this.note = "";
      this.$refs.observer.reset();
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
