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
        backgroundColor: { fill: 'transparent' },
        legend: { position: 'none' },
        colors: ['#F4511E', '#69F0AE'],
        vAxis:  { title: '' },
        hAxis:  { format: 'R$ ###,###,###.##', textStyle: { fontSize: 10 } },
        height: 300,
        bars: 'horizontal'
      }
    }
  },
  methods: {
    drawChart: function() {
      var data  = google.visualization.arrayToDataTable(this.content)
      var chart = new google.charts.Bar(document.getElementById(this.chartId))
      var that = this
      setTimeout(function() {
        chart.draw(data, google.charts.Bar.convertOptions(that.options))
      }, 50)
    }
  },
  created: function() {
    var that = this
    var path = '/api/users/' + this.userid + '/entries/by_month'
    $.get(path, (res) => { that.content = res })
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
