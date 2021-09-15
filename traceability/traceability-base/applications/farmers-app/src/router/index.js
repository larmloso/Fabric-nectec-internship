import Vue from 'vue'
import VueRouter from 'vue-router'

import store from '@/store'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: () => import('../views/Login.vue'),
    beforeEnter: (to, from, next) => {
      if (store.getters['auth/authenticated']) {
        return next({
          name: "Login"
        })
      }
      next();
    }
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('../views/Login.vue'),
    beforeEnter: (to, from, next) => {
      if (store.getters['auth/authenticated']) {
        return next({
          name: "Dashboard"
        })
      }
      next();
    }
  },
  {
    path: '/dashboard',
    name: 'Dashboard',
    component: () => import('../views/Dashboard.vue'),
    beforeEnter: (to, from, next) => {
      if (!store.getters['auth/authenticated']) {
        return next({
          name: "Login"
        })
      }
      next();
    }
  },
  {
    path: '/insert',
    name: 'Insert',
    component: () => import('../views/Insert.vue'),
    beforeEnter: (to, from, next) => {
      if (!store.getters['auth/authenticated']) {
        return next({
          name: "Login"
        })
      }
      next();
    }
  },
  // {
  //   path: '/scanqrcode',
  //   name: 'ScanQRCode',
  //   component: () => import('../views/ScanQRCode.vue'),
  // },
  {
    path: '/newproduct',
    name: 'NewProduct',
    component: () => import('../views/NewProduct.vue'),
    beforeEnter: (to, from, next) => {
      if (!to.params.ref) {
        return next({
          name: "Dashboard"
        })
      }
      next();
    }
  },
  {
    path: '/qrcodegen',
    name: 'qrcodegen',
    component: () => import('../views/QrcodeGenerator.vue'),
    beforeEnter: (to, from, next) => {
      if (!to.params.p_token) {
        return next({
          name: "Dashboard"
        })
      }
      next();
    }
  },
  {
    path: '/detail',
    name: 'detail',
    component: () => import('../views/Detail.vue'),
    beforeEnter: (to, from, next) => {
      if (!to.params.p_token) {
        return next({
          name: "Dashboard"
        })
      }
      next();
    }
  },
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
