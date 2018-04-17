<template>
  <div class="ls-box">
    <div class="ls-box-head">
      <h6 class="ls-title-4">DESPESAS</h6>
    </div>
    <div class="ls-box-body">
      <spinner v-if="loading" :size="'50'"></spinner>
      <strong v-else>
        {{ amount | currency }}
      </strong>
    </div>
  </div>
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
      console.log("atualizar despesa semanal")
      this.updateExpense()
    }
  },
  beforeMount: function() {
    var path = '/api/users/' + this.userid + '/expense/weekly'
    $.get(path, (res) => {
      this.amount  = res
      this.loading = false
    })
  },
  methods: {
    updateExpense: function() {
      this.loading = true
      var path = '/api/users/' + this.userid + '/expense/weekly'
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
