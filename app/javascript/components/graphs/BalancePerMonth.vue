<template>
  <div id="balance-per-month" style="width: 100%; height: auto;"></div>
</template>

<script>
export default {
  props: ['userid'],
  data () {
    return {
      balance: {
        current_balance: 0,
        balance_per_month: []
      },
      options: {
        size: { width: '100%' },
        legend: { position: 'none' }
      }
    }
  },
  created () {
    this.fetchData()
  },
  mounted () {
    google.charts.load('current', { 'packages': ['corechart', 'line'], 'language': 'pt-br' });
    google.charts.setOnLoadCallback(this.drawGraph);
  },
  methods: {
    drawGraph () {
      var data = google.visualization.arrayToDataTable(this.balance.balance_per_month);
      console.log(data)

      var chart = new google.visualization.LineChart(document.getElementById('balance-per-month'))
      chart.draw(data, this.options);
      chart.setSelection([{row: 2, column: 1}])
    },
    fetchData () {
      var path = '/api/users/' + this.userid + '/balance'
      $.get(path, (res) => {
        this.balance = res
        console.log(this.balance.balance_per_month)
      })
    }
  }
}
</script>
