import Vue from 'vue';
import Vuetify from 'vuetify/lib/framework';
import '@fortawesome/fontawesome-free/css/all.css'
import 'material-design-icons-iconfont/dist/material-design-icons.css'


Vue.use(Vuetify);

export default new Vuetify({
    icons: {
        iconfont: 'md' || 'fa'
    },
    theme: {
        themes: {
            light: {
                background: '#f6f8fa',
                footer: "#f6f8fa"
            },
            dark: {
                background: '#23262D',
                footer: "#23262D"
            }
        },
        dark: false,
        options: {
            customProperties: true
        },
    },

});
