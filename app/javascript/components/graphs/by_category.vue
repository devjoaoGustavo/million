<template>
  <div
    :id="chartid"
    @resize="drawChart"
    class="ls-full-width ls-height-auto ls-no-padding">
  </div>
</template>

<script>
export default {
  props: {
    chartid: String,
    data: Array
  },
  data: function() {
    return {
      options: {
        backgroundColor: {
          fill: 'transparent'
        },
        is3D: true,
        legend: {
          position: 'right',
          alignment: 'center'
        },
        chartArea: {
          width: '96%',
          height: '96%'
        }
      }
    }
  },
  methods: {
    drawChart: function() {
      var content = new google.visualization.arrayToDataTable(this.data)
      var chart   = new google.visualization
        .PieChart(document.getElementById(this.chartid))
      chart.draw(content, this.options)
    }
  },
  mounted: function() {
    google.charts.load('current', {'packages':['corechart'], 'language': 'pt-br' });
    google.charts.setOnLoadCallback(this.drawChart);
    window.addEventListener('resize', this.drawChart);
  },
  beforeDestroy: function() {
    window.removeEventListener('resize', this.drawChart);
  }
}
</script>
