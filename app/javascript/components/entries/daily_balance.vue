<template>
  <div class="ls-box">
    <div class="ls-box-head">
      <h6 class="ls-title-4">SALDO</h6>
    </div>
    <div class="ls-box-body">
      <spinner v-if="loading" :size="'50'"></spinner>
      <strong v-else :class="colorClass">
        {{ amount | currency }}
      </strong>
    </div>
  </div>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: ['userid', 'reload'],
  data: function() {
    return {
      amount:  0,
      loading: true
    }
  },
  watch: {
    reload: function() {
      this.updateBalance()
    }
  },
  computed: {
    colorClass: function() {
      return this.amount < 0.00 ? 'ls-color-danger' : 'ls-color-success'
    }
  },
  beforeMount: function() {
    var path = '/api/users/' + this.userid + '/balance/daily'
    $.get(path, (res) => {
      this.amount  = res
      this.loading = false
    })
  },
  methods: {
    updateBalance: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/balance/daily'
      $.get(path, (res) => {
        this.amount  = res
        this.loading = false
      })
    }
  },
  components: {
    'spinner': Loading
  }
}
</script>
