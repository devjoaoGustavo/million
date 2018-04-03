<template>
  <div v-bind:id="params.chartId" v-on:resize="drawChart" style="width: 100%; height: 400px;"></div>
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
        backgroundColor: '#f7f7f7',
        is3D: true,
        legend: { position: 'bottom' },
        chartArea: {
          top: 10,
          width: '75%',
          height: '75%'
        }
      },
      rows: [['Category', 'Amount'],['Supermercado', 340.90],['Conta de agua', 25.54],['Conta de luz', 105.54],['Investimento', 283.00],['Aluguel', 2200.00]]
    }
  },
  methods: {
    drawChart: function() {
      var content = new google.visualization.arrayToDataTable(this.$props.data)

      var chart = new google.visualization.PieChart(document.getElementById(this.$props.params.chartId))
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
