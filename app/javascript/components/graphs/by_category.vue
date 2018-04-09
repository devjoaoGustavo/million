<template>
  <div :id="params.chartId" @resize="drawChart" class="ls-full-width ls-height-auto ls-no-padding"></div>
</template>

<script>
export default {
  props: {
    params: Object,
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
      var content = new google.visualization.arrayToDataTable(this.$props.data)
      var chart   = new google.visualization
        .PieChart(document.getElementById(this.$props.params.chartId))
      chart.draw(content, this.$data.options)
    }
  },
  mounted: function() {
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(this.drawChart);
    window.addEventListener('resize', this.drawChart);
  },
  beforeDestroy: function() {
    window.removeEventListener('resize', this.drawChart);
  }
}
</script>
