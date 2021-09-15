<template>
  <v-container>
    <v-card color="fff" elevation="1">
      <v-row>
        <v-col cols="12" sm="6">
          <v-list-item three-line>
            <v-list-item-content>
              <div>
                <v-list-item-subtitle class="subtitle-1 mb-14 grey--text">
                  {{title}}
                </v-list-item-subtitle>
                <v-icon color="grey" x-large>{{icon}}</v-icon>
              </div>
            </v-list-item-content>
          </v-list-item>
        </v-col>
        <v-col cols="12" sm="6">
          <v-list-item three-line>
            <v-list-item-content class="text-right">
              <div>
                <v-list-item-subtitle class="subtitle-1 grey--text"
                  >742,728</v-list-item-subtitle
                >
                <v-list-item-subtitle class="grey--text" style="font-size: 11px"
                  >CHANG TO</v-list-item-subtitle
                >
                <v-list-item-subtitle
                  class="grey--text mb-5"
                  style="font-size: 11px"
                  >PREVOID MONTH</v-list-item-subtitle
                >
                <v-icon color="green" class="mt-2 mr-2">fas fa-sort-up</v-icon>
                <span class="green-text">+20,597</span><br />
                <span class="green--text">(2.16%)</span>
              </div>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-card>
  </v-container>
</template>
<script>
export default {
    name: 'card',
    props: {
        title: String,
        icon: String
    }
};
</script>
<style lang=""></style>
