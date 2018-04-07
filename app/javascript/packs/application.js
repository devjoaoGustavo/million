/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Vue from 'vue/dist/vue.esm'

import Intro from '../components/intro.vue'
import Alert from '../components/alert.vue'
import ByCategory from '../components/graphs/by_category.vue'
import Goals from '../components/goals/index.vue'

Vue.filter('currency', function(value) {
  return 'R$ ' + Number(value)
    .toFixed(2)
    .replace(',','')
    .replace('.',',')
    .replace(/(\d)(?=(\d{3})+\,)/g, "$1.");
});
Vue.filter('formatDate', function(value) {
  var date = new Date(value)
  return String('00' + date.getUTCDate()).slice(-2) + '/' + String('00' + (date.getUTCMonth() + 1)).slice(-2) + '/' + date.getUTCFullYear()
});

document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    components: {
      'intro': Intro,
      'alert': Alert,
      'by-category': ByCategory,
      'goals': Goals
    }
  });
  console.log(app)
})
