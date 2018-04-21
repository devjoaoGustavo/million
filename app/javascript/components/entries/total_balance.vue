<template>
    <div class="ls-box">
      <div class="ls-box-head">
        <h6 class="ls-title-4">SALDO</h6>
      </div>
      <div class="ls-box-body">
        <spinner v-if="loading" :size="'50'"></spinner>
        <strong v-else :class="amountClass">
          {{ balance | currency }}
        </strong>
      </div>
      <div class="ls-box-footer">
        <a :href="revenues_path" class="ls-tooltip-bottom ls-btn ls-btn-sm" aria-label="Abrir todas as receitas">Ver receitas</a>
        <a :href="expenses_path" class="ls-tooltip-bottom ls-btn ls-btn-sm" aria-label="Abrir todas as despesas">Ver despesas</a>
      </div>
    </div>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: ['userid', 'reload'],
  data: function() {
    return {
      balanceChanged: this.reload,
      balance: 0,
      revenues_path: '/users/'+this.userid+'/revenues',
      expenses_path: '/users/'+this.userid+'/expenses',
      loading: true
    }
  },
  watch: {
    reload: function() {
      this.updateBalance()
    }
  },
  computed: {
    amountClass: function() {
      return this.balance < 0 ? 'ls-color-danger' : 'ls-color-success'
    },
  },
  beforeMount: function() {
    var path = '/api/users/' + this.userid + '/balance'
    $.get(path, (res) => {
      this.balance = res
      this.loading = false
    })
  },
  methods: {
    updateBalance: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/balance'
      $.get(path, (res) => {
        this.balance = res
        this.loading = false
      })
    }
  },
  components: {
    'spinner': Loading
  }
}
</script>
