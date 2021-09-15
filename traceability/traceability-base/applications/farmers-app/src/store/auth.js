import axios from "axios"

const url = "http://larmdev.ml:3000";

export default ({
    namespaced: true,
    state: {
        token: null,
        user: null,
        basket: null
    },
    getters: {
        authenticated (state) {
            return state.token && state.user
        },
        user (state) {
            return state.user
        },

        basket (state) {
            return state.basket
        }

    },

    mutations: {
        SET_TOKEN (state, token) {
            state.token = token
        },

        SET_USER (state, data) {
            state.user = data
        },

        SET_basket (state, data) {
            state.basket = data
        }
    },

    actions: {
        async signIn ({ dispatch }, credentials) {
            let response = await axios.post(`${url}/api/auth/signin`, credentials);

            return dispatch('attempt', response.data.token)
        },

        async attempt ({ commit ,state}, token) {
            if(token) {
                commit('SET_TOKEN', token)
            }

            if(!state.token){
                return
            }

            try {
                let response = await axios.get(`${url}/api/auth/me`)
                commit('SET_USER', response.data.data.user)
            } catch (e) {
                console.log(e)
                commit('SET_TOKEN', null)
                commit('SET_USER', null)
            }
        },

        async signOut ({ commit }) {
            return await axios.delete(`${url}/api/auth/signout`).then(() => {
                commit('SET_TOKEN', null)
                commit('SET_USER', null)
                localStorage.clear();
            })

        },

        async basketProcess ({commit}, credential) {
            if (credential != 'null') {
                commit('SET_basket', credential)
            } else {
                commit('SET_basket', null)
            }
            
        }
    },
})
