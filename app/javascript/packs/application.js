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
import ExpenseDiary from '../components/expense_diary.vue'
import RevenueDiary from '../components/revenue_diary.vue'
import BalanceChart from '../components/graphs/balance.vue'
import CategoryChart from '../components/graphs/category.vue'
import PieChart from '../components/graphs/pie.vue'

document.addEventListener('DOMContentLoaded', () => {
    const app = new Vue({
        el: '#app',
        components: {
            'intro': Intro,
            'alert': Alert,
            'expense-diary': ExpenseDiary,
            'revenue-diary': RevenueDiary,
            'balance-chart': BalanceChart,
            'category-chart': CategoryChart,
            'pie-chart': PieChart
        }
    })

    console.log(app)
})
