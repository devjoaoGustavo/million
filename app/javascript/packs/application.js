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
import Goal from '../components/goals/show.vue'
import TotalBalance from '../components/entries/total_balance.vue'

import DailyBalance from '../components/entries/daily_balance.vue'
import DailyExpense from '../components/entries/daily_expense.vue'
import DailyRevenue from '../components/entries/daily_revenue.vue'

import WeeklyBalance from '../components/entries/weekly_balance.vue'
import WeeklyExpense from '../components/entries/weekly_expense.vue'
import WeeklyRevenue from '../components/entries/weekly_revenue.vue'

import MonthlyBalance from '../components/entries/monthly_balance.vue'
import MonthlyExpense from '../components/entries/monthly_expense.vue'
import MonthlyRevenue from '../components/entries/monthly_revenue.vue'

import NewEntry from '../components/entries/new.vue'
import GoalForm from '../components/goals/form.vue'

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
    data: {
      isNotice: false,
      isAlert: false,
      message: '',
      reloadBalance: false
    },
    components: {
      'intro': Intro,
      'alert': Alert,
      'by-category': ByCategory,
      'goals': Goals,
      'goal': Goal,
      'total-balance': TotalBalance,
      'daily-balance': DailyBalance,
      'daily-expense': DailyExpense,
      'daily-revenue': DailyRevenue,
      'weekly-balance': WeeklyBalance,
      'weekly-expense': WeeklyExpense,
      'weekly-revenue': WeeklyRevenue,
      'monthly-balance': MonthlyBalance,
      'monthly-expense': MonthlyExpense,
      'monthly-revenue': MonthlyRevenue,
      'new-entry': NewEntry,
      'goal-form': GoalForm
    },
    methods: {
      createdEntry: function(evt) {
        console.log(evt.responseJSON)
        this.reloadBalance = !this.reloadBalance
        this.message       = 'Nova entrada inserida com sucesso'
        this.isNotice      = true
      },
      failedEntry: function(evt) {
        this.message = 'A entrada não foi salva pelo seguinte problema: ' + evt.responseText
        this.isAlert = true
      },
      closeAlert: function() {
        this.message  = ''
        this.isNotice = false
        this.isAlert  = false
      },
      updatedGoal: function() {
        this.message  = 'Objetivo atualizado com sucesso'
        this.isNotice = true
      }
    }
  });
})
