<template>
  <div>
    <spinner v-show="loading" :size="'50'"></spinner>
    <div v-show="!loading" :id="chartid"></div>
  </div>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: {
    chartid: String,
    data: Array
  },
  data: function() {
    return {
      options: {
        backgroundColor: { fill: 'transparent' },
        pieHole: .4,
        pieStartAngle: 30,
        legend: {
          position: 'right',
          alignment: 'center'
        },
        chartArea: {
          width: '96%',
          height: '96%'
        }
      },
      loading: true
    }
  },
  methods: {
    drawChart: function() {
      var content = new google.visualization.arrayToDataTable(this.data)
      var chart   = new google.visualization.PieChart(document.getElementById(this.chartid))
      var that = this
      that.loading = false
      setTimeout(function() {
        chart.draw(content, that.options)
      }, 50)
    }
  },
  mounted: function() {
    google.charts.load('current', {'packages':['corechart'], 'language': 'pt-br' });
    google.charts.setOnLoadCallback(this.drawChart);
    screen.orientation.addEventListener('change', this.drawChart)
  },
  beforeDestroy: function() {
    screen.orientation.removeEventListener('change', this.drawChart)
  },
  components: {
    'spinner': Loading
  }
}
</script>
