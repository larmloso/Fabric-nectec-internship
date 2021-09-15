<template>
  <v-container>
    <v-row>
      <v-col cols="12" sm="12" md="5" offset-md="3">
        <template>
          <v-stepper v-model="e1">
            <v-stepper-header>
              <v-stepper-step :complete="e1 > 1" step="1">
                Recipient
              </v-stepper-step>

              <v-divider></v-divider>

              <v-stepper-step :complete="e1 > 2" step="2">
                QRCode
              </v-stepper-step>
            </v-stepper-header>

            <v-stepper-items>
              <v-stepper-content step="1">
                <v-btn color="primary" @click="setTransferAsset()">
                  Continue
                </v-btn>

                <v-btn text>
                  Cancel
                </v-btn>
              </v-stepper-content>

              <v-stepper-content step="2">
                <v-container>
                  <v-row>
                    <v-col>
                      <div class="d-flex justify-center  pa-5">
                        <qrcode-vue
                          id="mycanvas"
                          :value="value"
                          :size="size"
                          :margin="margin"
                          level="M"
                          class="pa-3 pb-1 bg-color"
                        />
                      </div>

                      <div class="d-flex justify-center pa-3">
                        <v-btn
                          outlined
                          color="primary"
                          dark
                          @click="DowloadQrcode()"
                          >download</v-btn
                        >
                      </div>
                    </v-col>
                  </v-row>
                </v-container>
              </v-stepper-content>
            </v-stepper-items>
          </v-stepper>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>
<script>
import QrcodeVue from "qrcode.vue";
import { mapGetters, mapActions } from "vuex";
export default {
  name: "qrcodegenerator",
  data() {
    return {
      size: 250,
      margin: 20,
      value: this.$route.params.p_token,
      e1: 1,
    };
  },
  components: {
    QrcodeVue,
  },
  mounted() {
    this.setProduct(this.value).then(() => {
      let result = this.getProduct();
      if (result.transferringStatus == true) {
        this.e1 = 2;
      }
    });
  },
  methods: {
    setTransferAsset() {
      try {
        this.e1 = 2;
        let data = {
          token: this.$route.params.p_token,
        };
        this.TransferAsset(data).then(() => {});
      } catch (error) {
        console.log(error);
      }
    },
    DowloadQrcode() {
      let canvasImage = document
        .getElementsByTagName("canvas")[0]
        .toDataURL("image/png");

      // this can be used to download any image from webpage to local disk
      let xhr = new XMLHttpRequest();
      xhr.responseType = "blob";
      xhr.onload = function() {
        let a = document.createElement("a");
        a.href = window.URL.createObjectURL(xhr.response);
        a.download = "image_name.png";
        a.style.display = "none";
        console.log(a);
        document.body.appendChild(a);
        a.click();
        a.remove();
      };
      xhr.open("GET", canvasImage); // This is to download the canvas Image
      xhr.send();
    },

    ...mapActions({
      TransferAsset: "eventData/TransferAsset",
      setProduct: "eventData/setProduct",
    }),

    ...mapGetters({
      getProduct: "eventData/getProduct",
    }),
  },
};
</script>
<style scoped>
.bg-color {
  background-color: #fff;
}
</style>
