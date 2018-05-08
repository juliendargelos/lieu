import VueRouter from 'vue-router'
import Vue from 'vue/dist/vue.esm'
import Books from './components/Books.vue'

Vue.use(VueRouter)

export default new VueRouter({
  mode: 'history',
  routes: [
    {
      path: '/books',
      name: 'Books',
      component: Books
    }
  ]
})
