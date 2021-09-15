<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="12" md="7" offset-md="2">
        <v-sheet color="white" elevation="1" rounded class="mb-3 show-sticky">
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center">
                <strong class="text-type">Create New Product</strong>
              </div>
              <div class="title-card align-self-center">
                <v-btn outlined color="red" small dark @click="Cancel()"
                  >cancel</v-btn
                >
              </div>
            </div>
          </div>
          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />

          <template>
            <validation-observer ref="observer" v-slot="{ invalid }">
              <form @submit.prevent="submit" class="pa-3">
                <div v-for="(item, index) in formNewProduct" :key="index">
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Type </span>
                    <strong>{{ ref[index].Record.type }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">User </span>
                    <strong>{{ ref[index].Record.user }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Creator </span>
                    <strong>{{ ref[index].Record.creator }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Amount </span>
                    <strong>{{ ref[index].Record.amount }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Datetime </span>
                    <strong>{{
                      Number(ref[index].Record.datetime) | moment
                    }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Timestamp </span>
                    <strong>{{
                      (Number(ref[index].Record.timestamp) * 1000) | moment
                    }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">TransferringStatus </span>
                    <strong
                      :class="
                        ref[index].Record.transferringStatus
                          ? 'text-condition-true'
                          : 'text-condition-false'
                      "
                      >{{ ref[index].Record.transferringStatus }}</strong
                    >
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">TransferredStatus </span>
                    <strong
                      :class="
                        ref[index].Record.transferredStatus
                          ? 'text-condition-true'
                          : 'text-condition-false'
                      "
                      >{{ ref[index].Record.transferredStatus }}</strong
                    >
                  </div>
                  <div class="text-token mt-2">
                    <span class="text-info-overflow">Token : </span>
                    <strong>{{ ref[index].Key }}</strong>
                  </div>

                  <div
                    v-for="(i, idx) in ref[index].Record.referrenceProductList"
                    :key="idx"
                  >
                    <div class="text-token">
                      <div class="pa-2 d-flex justify-space-between">
                        <div>
                          <span
                            style="font: 1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                            >token :{{ i.token }}</span
                          ><br />
                          <span
                            style="font: 1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                            >amount : {{ i.amount }}</span
                          >
                          <br />
                          <v-btn
                            outlined
                            color="rgba(9, 28, 114, 0.9)"
                            dark
                            icon
                            text
                            :to="{
                              name: 'detail',
                              params: { p_token: i.token },
                            }"
                            v-if="$vuetify.breakpoint.mobile"
                            ><v-icon>mdi-file-search</v-icon></v-btn
                          >
                        </div>
                        <div class="align-self-center">
                          <v-btn
                            outlined
                            color="rgba(9, 28, 114, 0.9)"
                            dark
                            icon
                            text
                            :to="{
                              name: 'detail',
                              params: { p_token: i.token },
                            }"
                            v-if="!$vuetify.breakpoint.mobile"
                            ><v-icon>mdi-file-search</v-icon></v-btn
                          >
                        </div>
                      </div>
                    </div>
                  </div>

                  <div v-if="ref[index].Record.note">
                    <div class="text-note">
                      <span class="text-info-overflow">Note : </span>
                      <span>{{ ref[index].Record.note }}</span>
                    </div>
                  </div>
                  <validation-provider
                    v-slot="{ errors }"
                    name="amount"
                    rules="required"
                  >
                    <strong class="text-label">Amount</strong>
                    <v-text-field
                      v-model.trim="formNewProduct[index].amount"
                      :error-messages="errors"
                      required
                      outlined
                      class="mt-2"
                      placeholder="amount number"
                      type="number"
                    ></v-text-field>
                  </validation-provider>
                  <hr
                    role="separator"
                    aria-orientation="horizontal"
                    class="v-divider theme--light mb-5"
                  />
                </div>

                <div>
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
                </div>
                <div>
                  
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
                      <strong class="text-label">Date time</strong>
                      <v-text-field
                        v-model="date"
                        prepend-inner-icon="mdi-calendar"
                        readonly
                        v-bind="attrs"
                        v-on="on"
                        required
                        class="mt-2"
                        outlined
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
                </div>
                <div>
                  <strong class="text-label">Note</strong>
                  <v-textarea
                    v-model.trim="note"
                    outlined
                    rows="3"
                    placeholder="note"
                    dense
                  ></v-textarea>
                </div>
                <div class="mt-2">
                  <v-tooltip top>
                    <template v-slot:activator="{ on, attrs }">
                      <v-btn
                        color="primary"
                        v-bind="attrs"
                        v-on="on"
                        class="mr-4 pa-6 pl-10 pr-10"
                        :block="$vuetify.breakpoint.mobile"
                        type="submit"
                        :disabled="invalid"
                        :loading="isLoadding"
                      >
                        Create
                      </v-btn>
                    </template>
                    <strong>create new product</strong>
                  </v-tooltip>
                </div>
              </form>
            </validation-observer>
          </template>
        </v-sheet>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import { required } from "vee-validate/dist/rules";
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
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
      ref: this.$route.params.ref,
      formNewProduct: [],
      isLoadding: false,
      type: "",
      note: "",
      date: new Date(Date.now() - new Date().getTimezoneOffset() * 60000)
        .toISOString()
        .substr(0, 10),
      menu: false,
      time: new Date(new Date().getTime()).toLocaleTimeString("en-GB"),
      datetime: "",
      refdataObj: [],
    };
  },

  computed: {
    ...mapGetters({
      user: "auth/user",
    }),
  },
  filters: {
    moment: function(date) {
      return moment(date).format("DD/MM/YYYY, h:mm:ss, a");
    },
  },
  mounted() {
    window.scrollTo(0, 0);
    for (let i = 0; i < this.$route.params.ref.length; i++) {
      this.formNewProduct.push({
        amount: "",
        token: this.$route.params.ref[i].Key,
      });
    }
  },
  methods: {
    ...mapActions({
      inSert: "eventdata/inSert",
      insertTransfer: "eventdata/insertTransfer",
      CreateProcess: "eventData/CreateProcess",
      basketProcess: "auth/basketProcess",
    }),
    submit() {
      this.isLoadding = true;
      this.datetime = `${this.date} ${this.time}`;
      this.$refs.observer.validate().then(() => {
        this.formNewProduct.forEach((e) => {
          this.refdataObj.push({
            token: e.token,
            amount: Number(e.amount),
          });
        });
        this.dataObj = {
          type: this.type,
          referrenceProductList: this.refdataObj,
          datetime: String(new Date(this.datetime).getTime()),
          note: this.note,
          user: this.user.givenName,
        };
        this.CreateProcess(this.dataObj).then(() => {
          this.isLoadding = false;
          this.basketProcess("null").then(() => {
            this.$router.push({ path: "/dashboard" });
          });
        });
      });
    },

    Cancel() {
      this.basketProcess("null").then(() => {
        this.$router.push({ path: "/dashboard" });
      });
    },
  },
};
</script>
<style scoped>
.card-header {
  min-height: 52px;
}
.theme--light.v-divider {
  border-color: rgba(0, 0, 0, 0.12);
}
.v-item-group {
  flex: 0 1 auto;
  max-width: 100%;
  transition: 0.1s;
  position: relative;
}
.text-token {
  display: inline-block;
  max-width: 100%;
  overflow: auto;
  /* text-overflow: ellipsis; */
  white-space: nowrap;
  background: rgba(235, 235, 235, 0.7);
  padding: 0.5rem;
  width: 100%;
  border-radius: 5px;
}
.text-note {
  display: inline-block;
  max-width: 100%;
  overflow: auto;
  /* text-overflow: ellipsis; */
  white-space: nowrap;
  background: rgba(241, 215, 84, 0.7);
  padding: 0.5rem;
  width: 100%;
  border-radius: 5px;
}
.text-data {
  color: rgba(0, 0, 0, 0.7);
}
.text-type {
  font-weight: 900;
  color: rgba(9, 28, 114, 0.9);
}
.text-info {
  font-size: 1rem;
  font-weight: 700;
  color: rgba(0, 0, 0, 0.5);
}

.text-info-overflow {
  font-size: 1rem;
  font-weight: 700;
  color: rgba(0, 0, 0, 1);
}

.text-condition-true {
  color: rgb(4, 167, 4);
  font-weight: 900;
}
.text-condition-false {
  color: rgba(9, 28, 114, 0.9);
  font-weight: 900;
}

.show-sticky {
  position: sticky;
  top: 90px;
}

.show-sticky-a {
  position: sticky;
  top: 300px;
}
</style>
