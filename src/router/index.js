import Vue from 'vue';
import VueRouter from 'vue-router';
import Home from '../views/Home.vue';
import Empl from '../views/Employees.vue';
import Orgs from '../views/Organisations.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home,
  },
  {
    path: '/employees',
    name: 'Employees',
    component: Empl,
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    //component: () =>import(/* webpackChunkName: "about" */ '../views/Employees.vue'),
  },
  {
    path: '/organisations',
    name: 'Organisations',
    component: Orgs,
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    //component: () => import(/* webpackChunkName: "about" */ '../views/Organisations.vue'),
  },
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
});

export default router;
