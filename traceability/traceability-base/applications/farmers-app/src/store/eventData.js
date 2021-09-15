import axios from "axios"

const url = "http://larmdev.ml:3500/api";
export default ({
    namespaced: true,
    state: {
        dataObj: null,
        insert: null,
        getProduct: null,
    },
    getters: {
        dataObj(state) {
            return state.dataObj
        },

        getProduct(state) {
            return state.getProduct
        }
    },

    mutations: {
        SET_DATA(state, data) {
            state.dataObj = data
        },

        INSERT_DATA(state, data) {
            state.inSert = data;
        },

        SETPRODUCT_DATA(state, data) {
            state.getProduct = data
        }
    },

    actions: {
        async filterData({ commit }, credentials) {

            if (credentials.filter == '' || credentials.method == '') {
                credentials.method = 'method'
                credentials.filter = 'filter'
            }
            if (credentials.filter == null || credentials.method == null) {
                credentials.method = 'method'
                credentials.filter = 'filter'
            }

            try {
                let response = await axios.get(`${url}/filters/${credentials.filter}/${credentials.method}/5/start`);
                commit('SET_DATA', response.data)
            } catch (error) {
                let response = await axios.get(`${url}/filters/${credentials.filter}/${credentials.method}/5/start`);
                commit('SET_DATA', response.data)
            }

        },


        async updatePage({ commit }, credentials) {
            let response = await axios.get(`${url}/filters/${credentials.filter}/${credentials.method}/5/${credentials.book_id}`);
            commit('SET_DATA', response.data)
        },

        async inSert({ commit }, credentials) {
            let token = localStorage.getItem('token', token);
            return await axios.post(`${url}/CreateAsset`, credentials).then((e) => {
                commit('INSERT_DATA', e.data)
            });
        },

        async CreateProcess({ commit }, credentials) {
            return await axios.post(`${url}/CreateProcess`, credentials).then((e) => {
                commit('INSERT_DATA', e.data)
            });
        },

        async setProduct({ commit }, credentials) {
            try {
                return await axios.get(`${url}/ReadAsset/${credentials}`).then((e) => {
                    commit('SETPRODUCT_DATA', e.data)
                });
            } catch (error) {
                let errdata = {
                    data: [],
                    status: 404,
                    message: 'error token'
                }
                commit('SETPRODUCT_DATA', errdata)
            }
        },

        async Receive({ commit }, credentials) {
            return await axios.post(`${url}/Receive/`, credentials).then((e) => {
                commit('INSERT_DATA', e.data)
            });
        },

        async TransferAsset({ commit }, credentials) {
            return await axios.post(`${url}/TransferAsset/`, credentials).then((e) => {
                commit('INSERT_DATA', e.data)
            });
        }

    },
})
