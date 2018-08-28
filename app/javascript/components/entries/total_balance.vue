<template>
  <v-container>
    <v-layout fill-height>
      <v-flex xs12>
        <strong v-if="!visible">
          <v-icon @click="see()">visibility</v-icon>
        </strong>
        <spinner v-else-if="loading" :size="'50'"></spinner>
        <template v-else>
          <span class="display-1" :class="amountClass">{{ balance.current_balance | currency }}</span>
          <br>
          <v-icon @click="see()">visibility_off</v-icon>
        </template>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: ['userid', 'reload'],
  data: function() {
    return {
      balance: { current_balance: 0, balance_per_month: [] },
      revenues_path: '/users/'+this.userid+'/revenues',
      expenses_path: '/users/'+this.userid+'/expenses',
      loading: true,
      visible: false
    }
  },
  watch: {
    reload: function() {
      this.updateBalance()
    }
  },
  computed: {
    amountClass: function() {
      return this.balance.current_balance < 0 ? 'deep-orange--text' : 'green--text'
    },
  },
  beforeMount: function() {
    var path = '/api/users/' + this.userid + '/balance'
    $.get(path, (res) => {
      this.balance = res
      console.log(this.balance)
      this.loading = false
    })
  },
  methods: {
    updateBalance: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/balance'
      $.get(path, (res) => {
        this.balance = res
        console.log(this.balance)
        this.loading = false
      })
    },
    see: function() {
      this.visible = !this.visible
    },
  },
  components: {
    'spinner': Loading
  }
}
</script>
