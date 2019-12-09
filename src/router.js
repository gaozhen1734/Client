import Vue from 'vue'
import VueRouter from 'vue-router'

import PostPage from './components/PostPage.vue'
import PostList from './components/PostList.vue'
import Signin from './components/Signin.vue'
import Signup from './components/Signup.vue'


Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'post-list',
    component: PostList
  },
  {
    path: '/signin',
    name: 'signin',
    component: Signin
  },
  {
    path: '/signup',
    name: 'signup',
    component: Signup
  },
  {
    path: '/post/:id',
    name: 'post-page',
    component: PostPage,
    props: true
  }
]

export default new VueRouter({
  mode: 'history',
  routes
})