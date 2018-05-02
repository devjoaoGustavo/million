<template>
  <v-container>
    <v-layout fill-height>
      <v-flex xs12 sm6 md6 offset-sm3 offset-md3>
        <spinner v-if="loading" :size="'50'"></spinner>
        <strong v-else>
          {{ amount | currency }}
        </strong>
      </v-flex>
    </v-layout>
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
    var path = '/api/users/' + this.userid + '/revenue/monthly'
    $.get(path, (res) => {
      this.amount  = res
      this.loading = false
    })
  },
  methods: {
    updateExpense: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/revenue/monthly'
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
