<template lang="">
  <v-container>
    <template>
      <v-sheet color="grey lighten-4">
        <v-row>
          <v-col cols="12" sm="12" md="3" offset-md="1">
            <v-skeleton-loader
              type="actions,divider,list-item-three-line,article"
            ></v-skeleton-loader>
            <v-skeleton-loader
              type="actions, divider, article"
            ></v-skeleton-loader>
          </v-col>
          <v-col cols="12" sm="12" md="6">
            <v-skeleton-loader
              v-for="i in 3"
              :key="i"
              type="image,divider, actions"
              class="mb-5"
            ></v-skeleton-loader>
          </v-col>
        </v-row>
      </v-sheet>
    </template>
  </v-container>
</template>
<script>
export default {};
</script>
