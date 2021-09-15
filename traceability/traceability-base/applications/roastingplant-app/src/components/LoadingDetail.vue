<template lang="">
  <v-container>
    <template>
      <v-sheet color="grey lighten-4">
        <v-row>
          <v-col cols="12" sm="12" md="6" offset-md="3">
            <v-skeleton-loader
              v-for="i in 3"
              :key="i"
              type="actions,divider, image"
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