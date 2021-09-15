<template>
  <v-footer dark padless v-if="$vuetify.breakpoint.mobile">
    <v-card flat tile class="white--text text-center" width="100%" color="rgba(216, 214, 214, 0.2)">
      <v-card-text class="white--text">
        {{ new Date().getFullYear() }} — <strong>UBU</strong>
      </v-card-text>
    </v-card>
  </v-footer>
</template>
<script>
export default {};
</script>

