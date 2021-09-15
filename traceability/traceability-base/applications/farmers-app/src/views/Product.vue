<template>
  <v-container>
    <Loading v-show="show" />
    <v-row>
      <v-col cols="12" sm="12" md="3" offset-md="1">
        <div class="show-sticky">
          <v-sheet color="white" elevation="1" rounded v-show="!show">
            <div class="card-header">
              <div
                class="pa-2 d-flex justify-space-between"
                style="min-height: 52px;"
              >
                <div class="title-card align-self-center">
                  <strong class="text-type">Filter</strong>
                </div>
                <div class="title-card align-self-center">
                  <span> {{ showtextfilter }}</span>
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
                <div>
                  <v-select
                    item-text="filter"
                    v-model="filterObj.filter"
                    :items="filterItem"
                    hide-details
                    outlined
                    class="mb-2"
                  ></v-select>
                </div>
                <div
                  v-if="
                    filterObj.filter == 'transferringStatus' ||
                      filterObj.filter == 'transferredStatus'
                  "
                >
                  <v-select
                    v-model="filterObj.method"
                    :items="['true', 'false']"
                    hide-details
                    outlined
                    class="mb-2"
                    @change="filterSearch()"
                  ></v-select>
                </div>
                <div v-if="filterObj.filter == 'filter'">
                  <v-select
                    v-model="filterObj.method"
                    item-text="all"
                    :items="['method']"
                    hide-details
                    outlined
                    class="mb-2"
                    @change="filterSearch()"
                  ></v-select>
                </div>
                <div
                  v-if="
                    filterObj.filter == 'user' ||
                      filterObj.filter == 'type' ||
                      filterObj.filter == 'note'
                  "
                >
                  <v-text-field
                    v-model.lazy="filterObj.method"
                    flat
                    prepend-inner-icon="search"
                    outlined-inverted
                    clearable
                    outlined
                    placeholder="search"
                    hide-details
                    @change="filterSearch()"
                  ></v-text-field>
                </div>
              </v-container>
            </template>
          </v-sheet>
        </div>
      </v-col>

      <!-- product list -->
      <v-col cols="12" sm="12" md="6">
        <div>
          <v-sheet
            elevation="1"
            rounded
            v-for="(item, i) in dataobj"
            :key="i"
            v-show="!show"
            id="infinite-list"
          >
            <div
              :class="[
                item.Record.transferredStatus
                  ? 'card-TransferredStatus'
                  : item.Record.transferringStatus
                  ? 'card-TransferringStatus'
                  : 'card-hover',
              ]"
            >
              <div
                class="pa-2 d-flex justify-space-between"
                style="min-height: 52px;"
              >
                <div class="title-card align-self-center ml-1">
                  <strong
                    style="font: 1.5rem 'Poppins', sans-serif; font-weight: 900; color: rgba(9, 28, 114, 0.9);"
                    >{{ item.Record.type }}</strong
                  >
                </div>
                <div>
                  <v-btn
                    icon
                    :to="{
                      name: 'detail',
                      params: { p_token: item.Key },
                    }"
                    class="title-card align-self-center"
                  >
                    <v-icon color="rgba(9, 28, 114, 0.9)"
                      >mdi-chevron-right</v-icon
                    >
                  </v-btn>
                </div>
              </div>
              <template>
                <v-container>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">User </span>
                    <span
                      style="font: 1.1rem 'Poppins', sans-serif; font-weight: 700; letter-spacing: 0.5px;"
                      >{{ item.Record.user }}</span
                    >
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Amount </span>
                    <strong>{{ item.Record.amount }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Datetime </span>
                    <strong>
                      {{ Number(item.Record.datetime) | moment }}
                    </strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">Timestamp </span>
                    <strong>{{
                      (Number(item.Record.timestamp) * 1000) | moment
                    }}</strong>
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span class="text-info">TransferringStatus </span>
                    <strong
                      :class="
                        item.Record.transferringStatus
                          ? 'text-condition-true'
                          : 'text-condition-false'
                      "
                      >{{ item.Record.transferringStatus }}</strong
                    >
                  </div>
                  <div class="text mb-1 d-flex justify-space-between">
                    <span
                      :class="
                        item.Record.transferredStatus
                          ? 'text-condition-true'
                          : 'text-info'
                      "
                      >TransferredStatus
                    </span>
                    <strong
                      :class="
                        item.Record.transferredStatus
                          ? 'text-condition-true'
                          : 'text-condition-false'
                      "
                      >{{ item.Record.transferredStatus }}</strong
                    >
                  </div>
                </v-container>
              </template>
            </div>
            <hr
              role="separator"
              aria-orientation="horizontal"
              class="v-divider theme--light"
            />
            <div class="card-header mb-3">
              <div class="pa-2 text-end" style="min-height: 52px;">
                <div>
                  <v-btn
                    :disabled="item.Record.transferredStatus"
                    v-if="!item.Record.transferringStatus == true"
                    elevation="0"
                    class="title-card align-self-center mr-2"
                    color="rgba(9, 28, 114, 0.9)"
                    outlined
                    style="text-transform: capitalize; font-weight: 900"
                    @click="newProuduct(item)"
                    :value="selected"
                  >
                    process
                    <v-icon>mdi-cart-variant</v-icon>
                  </v-btn>
                  <v-btn
                    :disabled="item.Record.transferredStatus"
                    v-if="!item.Record.transferringStatus == true"
                    elevation="0"
                    class="title-card align-self-center mr-2"
                    color="rgba(9, 28, 114, 0.9)"
                    style="text-transform: capitalize; font-weight: 900; color: #ffffff;"
                    :to="{
                      name: 'qrcodegen',
                      params: { p_token: item.Key },
                    }"
                  >
                    transfer
                    <v-icon>mdi-chevron-right</v-icon>
                  </v-btn>

                  <v-btn
                    v-if="item.Record.transferringStatus"
                    elevation="0"
                    class="title-card align-self-center"
                    color="rgba(9, 28, 114, 0.9)"
                    dark
                    style="text-transform: capitalize; font-weight: 900"
                    :to="{
                      name: 'qrcodegen',
                      params: { p_token: item.Key },
                    }"
                  >
                    QRCode
                    <v-icon>mdi-qrcode</v-icon>
                  </v-btn>
                </div>
              </div>
            </div>
          </v-sheet>
        </div>
        <template>
          <div>
            <LoadingItem v-show="isLoadingProduct" />
          </div>
        </template>
      </v-col>
    </v-row>
    <div
      v-if="dataobj.length"
      v-observe-visibility="handleScrolledToButtom"
    ></div>
  </v-container>
</template>
<script>
import Loading from "../components/Loading.vue";
import LoadingItem from "../components/LoadingItem.vue";
import { mapGetters, mapActions } from "vuex";
import moment from "moment";
export default {
  data() {
    return {
      dataobj: [],
      bookmark: "",
      disabledLen: "",
      show: false,
      filterObj: { filter: "", method: "" },
      showtextfilter: "",
      isLoadingProduct: false,
      selected: [],
      newItemProuduct: [],
      filterItem: [
        {
          filter: "filter",
        },
        {
          filter: "type",
        },
        {
          filter: "user",
        },
        {
          filter: "note",
        },
        {
          filter: "transferringStatus",
        },
        {
          filter: "transferredStatus",
        },
      ],
    };
  },
  components: {
    Loading,
    LoadingItem,
  },
  computed: {
    ...mapGetters({
      getDataObj: "eventData/dataObj",
    }),
  },
  filters: {
    moment: function(date) {
      return moment(date).format("DD/MM/YYYY, h:mm:ss, a");
    },
  },
  mounted() {
    this.show = true;
    window.scrollTo(0, 0);
    try {
      this.filterData({
        filter: localStorage.getItem("filter"),
        method: localStorage.getItem("method"),
      }).then(() => {
        this.getDataObj.data.forEach((e) => {
          this.dataobj.push(e);
        });
        let item = this.dataobj;
        this.dataobj = [...new Set(item)];
        this.bookmark = this.getDataObj.ResponseMetadata.bookmark;
        this.show = false;
      });
    } catch (error) {
      this.show = false;
      console.log(error);
    }

    this.showtextfilter = `${localStorage.getItem(
      "filter"
    )}/${localStorage.getItem("method")}`;
  },
  methods: {
    ...mapActions({
      filterData: "eventData/filterData",
      updatePage: "eventData/updatePage",
      basketProcess: "auth/basketProcess",
    }),

    filterSearch() {
      this.show = true;
      window.scrollTo(0, 0);
      localStorage.setItem("filter", `${this.filterObj.filter}`);
      localStorage.setItem("method", `${this.filterObj.method}`);
      this.showtextfilter = `${localStorage.getItem(
        "filter"
      )}/${localStorage.getItem("method")}`;
      this.filterData({
        filter: localStorage.getItem("filter"),
        method: localStorage.getItem("method"),
      }).then(() => {
        this.dataobj.splice(0);
        this.bookmark = this.getDataObj.ResponseMetadata.bookmark;
        this.getDataObj.data.forEach((e) => {
          this.dataobj.push(e);
        });
        let item = this.dataobj;
        this.dataobj = [...new Set(item)];
        this.show = false;
        this.filterObj.method = "";
      });
    },

    async handleScrolledToButtom(isVisible) {
      if (this.getDataObj.data.length == 0) {
        this.isLoadingProduct = false;
        return;
      }
      this.isLoadingProduct = true;
      this.updatePage({
        book_id: this.bookmark,
        filter: localStorage.getItem("filter"),
        method: localStorage.getItem("method"),
      }).then(() => {
        if (this.getDataObj.data.length == 0) {
          this.isLoadingProduct = false;
          return;
        }
        if (!isVisible) {
          return;
        }
        this.bookmark = this.getDataObj.ResponseMetadata.bookmark;
        this.getDataObj.data.forEach((e) => {
          this.dataobj.push(e);
        });
        let item = this.dataobj;
        this.dataobj = [...new Set(item)];
        this.isLoadingProduct = false;
      });
    },

    newProuduct(value) {
      this.newItemProuduct.push(value);
      let item = this.newItemProuduct;
      this.newItemProuduct = [...new Set(item)];

      if (this.newItemProuduct != 0) {
        if (item.length != this.newItemProuduct.length) {
          //console.log("==");
        } else {
          //console.log("!=");
        }
      }

      this.basketProcess(this.newItemProuduct).then(() => {});
    },

    DeleteField(index) {
      if (index > -1) {
        this.newItemProuduct.splice(index, 1);
      }
    },
  },

  destroyed() {
    this.dataobj.splice(0);
    this.bookmark = "start";
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

.card-hover:hover {
  cursor: pointer;
  background-color: rgba(216, 214, 214, 0.2);
  color: rgb(0, 0, 0);
}
.card-TransferredStatus {
  background-color: rgb(199, 199, 199);
}
.card-TransferringStatus {
  background-color: rgb(255, 199, 161);
}
</style>
