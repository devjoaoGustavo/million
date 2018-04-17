<template>
  <div class="ls-box ls-board-box">
    <header class="ls-info-header ls-sm-space">
      <h2 class="ls-title-3 ls-xs-margin-top ls-xs-margin-left">Nova entrada</h2>
      <div class="ls-tabs-btn ls-float-right">
        <ul class="ls-tabs-btn-nav">
          <li class="col-md-6 col-xs-6 col-sm-6">
            <label class="ls-btn ls-xs-space ls-text-xs" data-ls-module="button" :aria-selected="entrytype == 'revenue'" @click="selectRevenue()">
              Receita
            </label>
          </li>
          <li class="'col-md-6 col-xs-6 col-sm-6 ls-active">
            <label class="ls-btn ls-xs-space ls-text-xs" data-ls-module="button" :aria-selected="entrytype == 'expense'" @click="selectExpense()">
              Despesa
            </label>
          </li>
        </ul>
      </div>
    </header>
    <div id="sending-stats">
      <div class="ls-box">
        <spinner v-if="loading" :size="'100'"></spinner>
        <form v-else class="ls-form ls-form-horizontal ls-no-padding" @submit.prevent="" data-ls-module="form">
          <div class="lx-box-body row">
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <b class="ls-label-text ls-hidden-accessible">Envelope</b>
              <div class="ls-custom-select ls-field-sm">
                <select name="category_id" class="ls-custom" v-model="categoryId">
                  <option value="">Envelope...</option>
                  <option v-for="category in categories" :value="category.id">{{ category.name }}</option>
                </select>
              </div>
            </label>
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <b class="ls-label-text ls-hidden-accessible">Descrição</b>
              <input class="ls-field-sm" type="text" name="description" placeholder="Descrição" v-model="description">
            </label>
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-no-margin-bottom ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <input class="ls-mask-money ls-field-sm" type="number" name="amount" min="0.00" step="0.01" placeholder="Valor (ex: 21,56)" v-model="amount">
              <small class="ls-label-text ls-color-theme">Valor</small>
            </label>
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <input id="entry_date" class="ls-field-sm" type="date" name="entry_date" placeholder="dd/mm/aaaa" v-model="entryDate" style="height: 30px;">
              <small class="ls-label-text ls-color-theme ls-no-margin">Data</small>
            </label>
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-xs-margin-bottom ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <input class="ls-txt-center ls-field-sm" type="number" name="installments" min="1" step="1" Value="1" v-model="installments">
              <small class="ls-label-text ls-color-theme ls-no-margin">Parcelas</small>
            </label>
            <label class="ls-label col-md-4 col-xs-12 ls-txt-left ls-xs-space ls-no-padding-top ls-no-padding-bottom">
              <b class="ls-label-text ls-hidden-accessible">Objetivo</b>
              <div class="ls-custom-select ls-field-sm">
                <select name="goal_id" class="ls-custom" v-model="goalId">
                  <option value="">Objetivo...</option>
                  <option v-for="goal in goals" :value="goal.id">{{ goal.title }}</option>
                </select>
              </div>
            </label>
          </div>
          <div class="ls-box-footer ls-xs-space ls-no-padding-top ls-no-padding-bottom">
            <div class="ls-actions-btn ls-xs-space ls-no-padding-bottom ls-no-margin">
              <button class="ls-btn-prinary ls-btn-sm" @click="saveEntry()">Salvar</button>
              <button class="ls-btn-danger ls-btn-sm" @click="clear()">Cancelar</button>
            </div>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: {
    options: Object
  },
  data: function() {
    return {
      categories: [],
      goals: [],
      type: this.entrytype,
      categoryId: '',
      description: '',
      amount: '',
      entryDate: '',
      entrytype: 'expense',
      goalId: '',
      installments: 1,
      loading: true
    }
  },
  beforeMount: function() {
    var path = '/api/categories'
    $.get(path, (res) => {
     this.categories = res
    })
    path = '/api/users/' + this.options.userid + '/goals'
    $.get(path, (res) => {
      this.goals   = res
      this.loading = false
    })
  },
  methods: {
    saveEntry: function() {
      var input = {
        category_id:        this.categoryId,
        description:        this.description,
        amount:             this.amount,
        entry_date:         this.entryDate,
        type:               this.entrytype,
        goal_id:            this.goalId,
        installments:       this.installments,
        authenticity_token: this.options.token
      }
      console.log(input)
      var path = '/api/users/'+this.options.userid+'/entries'
      $.ajax({
        url: path,
        method: 'POST',
        data: input,
        success: (res) => {
          console.log(res)
          this.$emit('entrycreated', res)
          this.clear()
        },
        error: (res) => {
          this.$emit('entryfailed', res)
        }
      })
    },
    clear: function() {
      this.categoryId   = ''
      this.description  = ''
      this.amount       = ''
      this.entryDate    = ''
      this.entrytype    = 'expense'
      this.goalId       = ''
      this.installments = 1
    },
    selectExpense: function() {
      this.entrytype = 'expense'
    },
    selectRevenue: function() {
      this.entrytype = 'revenue'
    },
    defaultDate: function() {
      var date = new Date()
      return date.getUTCFullYear() + '-' + String('00' + (date.getUTCMonth() + 1)).slice(-2) + '-' + String('00' + date.getUTCDate()).slice(-2)
    }
  },
  components: {
    'spinner': Loading
  }
}
</script>
