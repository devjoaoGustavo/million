<template>
  <span v-if="content.lenght == 1">Não há entradas</span>
  <div v-else id="chart-by-month" :style="size"></div>
</template>

<script>
export default {
  props: ['userid'],
  data: function() {
    return {
      content: [['Mês', 'Despesas', 'Receitas']],
      size: {
        width: '100%',
        height: 'auto'
      },
      options: {
        backgroundColor: {
          fill: 'transparent'
        },
        legend: {
          alignment: 'center',
          position: 'none'
        },
        colors: ['red', 'green'],
        hAxis: { legend: 'none' },
        vAxis: { format: 'R$ ###,###,###.##' },
        height: 400
      }
    }
  },
  methods: {
    drawChart: function() {
      var data  = google.visualization.arrayToDataTable(this.content)
      var chart = new google.charts.Bar(this.$el)
      chart.draw(data, google.charts.Bar.convertOptions(this.options))
    }
  },
  created: function() {
    var that = this
    var path = '/api/users/' + this.userid + '/entries/by_month'
    $.get(path, (res) => { that.content = res, console.log(that.content) })
  },
  mounted: function() {
    google.charts.load('current', { 'packages': ['bar'], 'language': 'pt-br' })
    google.charts.setOnLoadCallback(this.drawChart)
    window.addEventListener('resize', this.drawChart)
  },
  beforeDestroy: function() {
    window.removeEventListener('resize', this.drawChart)
  }
}
</script>
