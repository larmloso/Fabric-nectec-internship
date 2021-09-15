<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="12" md="4" offset-md="4">
        <v-sheet color="white" elevation="1" rounded class="mb-3 show-sticky">
          <div class="card-header">
            <div
              class="pa-2 d-flex justify-space-between"
              style="min-height: 52px;"
            >
              <div class="title-card align-self-center">
                <strong class="text-type">Scan QRCode</strong>
              </div>
              <div class="title-card align-self-center"></div>
            </div>
          </div>
          <hr
            role="separator"
            aria-orientation="horizontal"
            class="v-divider theme--light"
          />

          <template>
            <v-container>
              <div>
                <qrcode-stream
                  :camera="camera"
                  @decode="onDecode"
                  @init="onInit"
                >
                  <div
                    v-show="showScanConfirmation"
                    class="scan-confirmation justify-center align-center"
                    align="center"
                  >
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      x="0px"
                      y="0px"
                      width="128"
                      height="128"
                      viewBox="0 0 172 172"
                      style=" fill:#000000;"
                    >
                      <g
                        fill="none"
                        fill-rule="nonzero"
                        stroke="none"
                        stroke-width="none"
                        stroke-linecap="none"
                        stroke-linejoin="miter"
                        stroke-miterlimit="10"
                        stroke-dasharray=""
                        stroke-dashoffset="0"
                        font-family="none"
                        font-weight="none"
                        font-size="none"
                        text-anchor="none"
                        style="mix-blend-mode: normal"
                      >
                        <path
                          d="M0,172v-172h172v172z"
                          fill="none"
                          stroke="none"
                          stroke-width="1"
                          stroke-linecap="butt"
                        ></path>
                        <g>
                          <path
                            d="M86,21.5c-35.62237,0 -64.5,28.87763 -64.5,64.5c0,35.62237 28.87763,64.5 64.5,64.5c35.62237,0 64.5,-28.87763 64.5,-64.5c0,-35.62237 -28.87763,-64.5 -64.5,-64.5z"
                            fill="#ffffff"
                            stroke="none"
                            stroke-width="1"
                            stroke-linecap="butt"
                          ></path>
                          <path
                            d="M86,33.59375c-28.94317,0 -52.40625,23.46308 -52.40625,52.40625c0,28.94317 23.46308,52.40625 52.40625,52.40625c28.94317,0 52.40625,-23.46308 52.40625,-52.40625c0,-28.94317 -23.46308,-52.40625 -52.40625,-52.40625z"
                            fill="#2ecc71"
                            stroke="none"
                            stroke-width="1"
                            stroke-linecap="butt"
                          ></path>
                          <path
                            d="M86,21.5c-35.62237,0 -64.5,28.87763 -64.5,64.5c0,35.62237 28.87763,64.5 64.5,64.5c35.62237,0 64.5,-28.87763 64.5,-64.5c0,-35.62237 -28.87763,-64.5 -64.5,-64.5z"
                            fill="none"
                            stroke="#2ecc71"
                            stroke-width="8.0625"
                            stroke-linecap="butt"
                          ></path>
                          <path
                            d="M56.4375,92.71875l18.20781,16.125l40.91719,-47.03125"
                            fill="none"
                            stroke="#ffffff"
                            stroke-width="8.0625"
                            stroke-linecap="round"
                          ></path>
                        </g>
                      </g>
                    </svg>
                  </div>
                </qrcode-stream>
              </div>
            </v-container>
          </template>
        </v-sheet>
      </v-col>
    </v-row>

    <v-row>
      <v-col cols="12" sm="12" md="8" offset-md="2">
        <v-dialog
          v-model="dialog"
          :fullscreen="$vuetify.breakpoint.mobile"
          persistent
          max-width="800px"
        >
          <v-sheet color="white" elevation="1" rounded class="mb-3 show-sticky">
            <div class="card-header">
              <div
                class="pa-2 d-flex justify-space-between"
                style="min-height: 52px;"
              >
                <div class="title-card align-self-center">
                  <strong class="text-type">Product Details</strong>
                </div>
                <div class="title-card align-self-center"></div>
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
                  <span class="text-info">Type </span>
                  <strong>{{ this.product.type }}</strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">User </span>
                  <strong>{{ this.product.user }}</strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">User </span>
                  <strong>{{ this.product.creator }}</strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">Amount </span>
                  <strong>{{ this.product.amount }}</strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">Datetime </span>
                  <strong>{{
                    (Number(this.product.datetime)) | moment
                  }}</strong>
                </div>
                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">Timestamp </span>
                  <strong>{{
                    (Number(this.product.timestamp) * 1000) | moment
                  }}</strong>
                </div>

                <div class="text mb-1 d-flex justify-space-between">
                  <span class="text-info">TransferringStatus </span>
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
                  <span class="text-info">TransferredStatus </span>
                  <strong
                    :class="
                      this.product.transferredStatus
                        ? 'text-condition-true'
                        : 'text-condition-false'
                    "
                    >{{ this.product.transferredStatus }}</strong
                  >
                </div>
                <div class="text-token mt-2">
                  <span class="text-info-overflow">Token : </span>
                  <strong>{{ this.product.token }}</strong>
                </div>

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

                <div v-if="this.product.note">
                  <div class="text-note">
                    <span class="text-info-overflow">Note : </span>
                    <span>{{ this.product.note }}</span>
                  </div>
                </div>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="closeProduct()">
                    Close
                  </v-btn>
                  <v-btn
                    color="blue darken-1"
                    text
                    @click="confirmProduct('hello')"
                  >
                    Save
                  </v-btn>
                </v-card-actions>
              </v-container>
            </template>
          </v-sheet>
        </v-dialog>
      </v-col>

      <v-col cols="12" sm="12" md="8" offset-md="2">
        <v-dialog
          v-model="isErrorDialog"
          :fullscreen="$vuetify.breakpoint.mobile"
          persistent
          max-width="800px"
          height="100%"
        >
          <v-sheet color="white" elevation="1" rounded class="mb-3 show-sticky">
            <div class="card-header">
              <div
                class="pa-2 d-flex justify-space-between"
                style="min-height: 52px;"
              >
                <div class="title-card align-self-center">
                  <strong class="text-type">Not found data</strong>
                </div>
                <div class="title-card align-self-center"></div>
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
                  <span class="text-info" color="red">Error </span>
                  <strong color="red">{{ this.product.message }}</strong>
                </div>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="red" text @click="closeProduct()">
                    Close
                  </v-btn>
                </v-card-actions>
              </v-container>
            </template>
          </v-sheet>
        </v-dialog>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { QrcodeStream } from "vue-qrcode-reader";
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
export default {
  components: { QrcodeStream },

  data() {
    return {
      camera: "auto",
      result: null,
      showScanConfirmation: false,
      dialog: false,
      product: "",
      isErrorDialog: false,
    };
  },
  filters: {
    moment: function(date) {
      return moment(date).format("DD/MM/YYYY, h:mm:ss, a");
    },
  },

  methods: {
    async onInit(promise) {
      try {
        await promise;
      } catch (e) {
        console.error(e);
      } finally {
        this.showScanConfirmation = this.camera === "off";
      }
    },

    async onDecode(content) {
      this.result = content;

      this.pause();
      await this.timeout(500);
      this.unpause();

      try {
        this.setProduct(content).then(() => {
          if (this.getProduct().status == 404) {
            this.isErrorDialog = true;
            this.product = this.getProduct();
          } else {
            this.product = this.getProduct();
            this.dialog = true;
          }
        });
      } catch (error) {
        console.log(error);
      }
      this.camera = "off";
    },

    unpause() {
      this.camera = "auto";
    },

    pause() {
      this.camera = "off";
    },

    confirmProduct() {
      this.dialog = false;
      this.camera = "auto";
      let data = {
        token: this.product.token,
      };
      try {
        this.Receive(data).then(() => {
          console.log("saved");
        });
      } catch (error) {
        console.log(error);
      }
    },
    closeProduct() {
      this.dialog = false;
      this.isErrorDialog = false;
      this.camera = "auto";
    },

    timeout(ms) {
      return new Promise((resolve) => {
        window.setTimeout(resolve, ms);
      });
    },

    stopCameraStream() {
      this.camera = "off";
    },
    ...mapActions({
      setProduct: "eventData/setProduct",
      Receive: "eventData/Receive",
    }),

    ...mapGetters({
      getProduct: "eventData/getProduct",
    }),
  },
};
</script>

<style scoped>
.scan-confirmation {
  position: absolute;
  width: 100%;
  height: 100%;

  background-color: rgba(255, 255, 255, 0.8);

  display: flex;
  flex-flow: row nowrap;
  justify-content: center;
}

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
</style>
