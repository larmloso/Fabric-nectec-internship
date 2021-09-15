<template>
  <v-container>
    <LoadingDetail v-show="isLoadingItem" />
    <v-row>
      <!-- product list -->
      <v-col cols="12" sm="12" md="6" offset-md="3">
        <v-sheet
          elevation="1"
          rounded
          v-show="!isLoadingItem"
          id="infinite-list"
        >
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center ml-1">
                <strong
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                  >Detailed information</strong
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
            <v-container>
              <div class="text mb-1 d-flex justify-space-between">
                <span
                  class="text-info"
                  style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                  >Type
                </span>
                <span
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 700; letter-spacing: 0.5px;"
                  >{{ this.product.type }}</span
                >
              </div>
              <div class="text mb-1 d-flex justify-space-between">
                <span
                  class="text-info"
                  style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                  >Amount
                </span>
                <span
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 700; letter-spacing: 0.5px;"
                  >{{ this.product.amount }}</span
                >
              </div>
              <div class="text mb-1 d-flex justify-space-between">
                <span
                  class="text-info"
                  style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                  >Username
                </span>
                <span
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 700; letter-spacing: 0.5px;"
                  >{{ this.product.user }}</span
                >
              </div>
              <div class="text mb-1 d-flex justify-space-between">
                <span
                  class="text-info"
                  style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                  >Creator
                </span>
                <span
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 700; letter-spacing: 0.5px;"
                  >{{ this.product.creator }}</span
                >
              </div>
              <div class="text-token mt-2">
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    >Datetime
                  </span>
                  <strong>
                    {{ Number(this.product.datetime) | moment }}
                  </strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    >Timestamp
                  </span>
                  <strong>{{
                    (Number(this.product.timestamp) * 1000) | moment
                  }}</strong>
                </div>
              </div>
              <div class="text-token mt-2">
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    >TransferringStatus
                  </span>
                  <strong
                    :class="
                      this.product.transferringStatus
                        ? 'text-condition-true'
                        : 'text-condition-false'
                    "
                    >{{ this.product.transferringStatus }}</strong
                  >
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    v-if="this.product.transferringtime != null"
                    >Transferringtime
                  </span>
                  <strong
                    v-if="this.product.transferringtime != null"
                    :class="
                      this.product.transferringStatus
                        ? 'text-condition-true'
                        : 'text-condition-false'
                    "
                    >{{
                      (Number(this.product.transferringtime) * 1000) | moment
                    }}</strong
                  >
                </div>
              </div>
              <div class="text-token mt-2">
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    >TransferredStatus
                  </span>
                  <strong
                    :class="
                      this.product.transferredStatus
                        ? 'text-condition-true'
                        : 'text-condition-false'
                    "
                    >{{ this.product.transferredStatus }}</strong
                  >
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span
                    class="text-info"
                    style="font: 1rem 'Poppins', sans-serif; font-weight: 500; letter-spacing: 0.5px;"
                    v-if="this.product.transferredtime != null"
                    >Transferredtime
                  </span>
                  <strong
                    v-if="this.product.transferredtime != null"
                    :class="
                      this.product.transferredtime
                        ? 'text-condition-true'
                        : 'text-condition-false'
                    "
                    >{{
                      (Number(this.product.transferredtime) * 1000) | moment
                    }}</strong
                  >
                </div>
              </div>
            </v-container>
          </template>
          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center ml-1">
                <strong
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                  >Token</strong
                >
              </div>
            </div>
          </div>
          <v-container>
            <template>
              <div class="text-token">
                <strong>{{ this.product.token }}</strong>
              </div>
            </template>
          </v-container>

          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center ml-1">
                <strong
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                  >ReferrenceProductList</strong
                >
              </div>
            </div>
          </div>
          <v-container>
            <div
              v-for="(i, idx) in this.product.referrenceProductList"
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
                      @click="updatePage(i.token)"
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
                      @click="updatePage(i.token)"
                      v-if="!$vuetify.breakpoint.mobile"
                      ><v-icon>mdi-file-search</v-icon></v-btn
                    >
                  </div>
                </div>
              </div>
            </div>
          </v-container>

          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center ml-1">
                <strong
                  style="font: 1.1rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                  >Note</strong
                >
              </div>
            </div>
          </div>
          <v-container>
            <div v-if="this.product.note">
              <div class="text-note">
                <span class="text-info-overflow">Note : </span>
                <span>{{ this.product.note }}</span>
              </div>
            </div>
          </v-container>
        </v-sheet>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import LoadingDetail from "../components/LoadingDetail.vue";
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
export default {
  data() {
    return {
      product: "",
      isLoadingItem: false,
    };
  },

  components: {
    LoadingDetail,
  },

  mounted() {
    this.isLoadingItem = true;
    this.setProduct(this.$route.params.p_token).then(() => {
      this.product = this.getProduct();
      this.isLoadingItem = false;
    });
  },

  methods: {
    ...mapActions({
      setProduct: "eventData/setProduct",
      TransferAsset: "eventData/TransferAsset",
    }),

    ...mapGetters({
      getProduct: "eventData/getProduct",
    }),

    updatePage(value) {
      this.isLoadingItem = true;
      this.setProduct(value).then(() => {
        this.product = this.getProduct();
        this.isLoadingItem = false;
      });
    },

    setTransferAsset() {
      try {
        let data = {
          token: this.product.token,
        };
        this.TransferAsset(data).then(() => {
        });
      } catch (error) {
        console.log(error)
      }
    },
  },

  filters: {
    moment: function(date) {
      return moment(date).format("DD/MM/YYYY, h:mm:ss, a");
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
  text-transform: capitalize;
}
.text-info {
  font-size: 1rem;
  color: rgba(46, 49, 49, 0.7);
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
/* .card-hover:hover {
  cursor: pointer;
  background-color: rgba(216, 214, 214, 0.2);
  color: rgb(0, 0, 0);
} */
.card-color {
  background-color: rgb(199, 199, 199);
}
</style>
