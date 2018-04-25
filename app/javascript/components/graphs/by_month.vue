<template>
  <div :id="chartId" :style="size"></div>
</template>

<script>
export default {
  props: ['userid'],
  data: function() {
    return {
      chartId: 'chart-by-month',
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
      var chart = new google.charts.Bar(document.getElementById(this.chartId))
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
    screen.orientation.addEventListener('change', this.drawChart)
  },
  beforeDestroy: function() {
    screen.orientation.removeEventListener('change', this.drawChart)
  }
}
</script>
