import Vue from 'vue'
import Vuex from 'vuex'
import auth from './auth'
import eventData from './eventData'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
  },

  mutations: {
  },

  actions: {
  },

  modules: {
    auth,
    eventData
  }
})
