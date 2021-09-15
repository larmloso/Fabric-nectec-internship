import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import vuetify from './plugins/vuetify'
// import axios from 'axios'

import VueObserveVisibility from 'vue-observe-visibility'

Vue.use(VueObserveVisibility)


require('@/store/subscriber')

Vue.config.productionTip = false

// axios.defaults.baseURL = 'http://larmdev.tech:3000/';

store.dispatch('auth/attempt', localStorage.getItem('token')).then(() => {
  new Vue({
    router,
    store,
    vuetify,
    render: h => h(App)
  }).$mount('#app')
})

