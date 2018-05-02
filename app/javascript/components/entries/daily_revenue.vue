<template>
  <v-container>
    <spinner v-if="loading" :size="'50'"></spinner>
    <strong v-else>
      {{ amount | currency }}
    </strong>
  </v-container>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: ['userid','reload'],
  data: function() {
    return {
      amount: 0,
      loading: true
    }
  },
  watch: {
    reload: function() {
      this.updateExpense()
    }
  },
  beforeMount: function() {
    var path = '/api/users/' + this.userid + '/revenue/daily'
    $.get(path, (res) => {
      this.amount  = res
      this.loading = false
    })
  },
  methods: {
    updateExpense: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/revenue/daily'
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
