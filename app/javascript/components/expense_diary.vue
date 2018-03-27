<template>
  <div v-bind:id="params.chartId" v-on="makeChart(data)" v-bind:style="'width: 100%; ' + 'height: ' + params.size.height + 'px;'"></div>
</template>

<script>
export default {
  props: {
    params: Object,
    data: Array
  },
  methods: {
    makeChart: function(data) {
      AmCharts.makeChart(this.$props.params.chartId, {
        "type":          "serial",
        "theme":         "light",
        "color":         "#000000",
        "categoryField": "category",
        "dataProvider":  data,
        "valueAxes": [ {
          "gridColor": "#FFFFFF",
          "gridAlpha": 0.2,
          "dashLength": 0
        } ],
        "gripAboveGraphs": true,
        "startDuration": 1,
        "graphs":        [
          {
            "balloonText": "[[category]]: <b>[[amount]]</b>",
            "fillAlphas": 0.8,
            "lineAlpha": 0.2,
            "type":       "column",
            "valueField": "amount"
          }
        ],
        "chartCursor": {
          "categoryBalloonEnabled": false,
          "cursorAlpha": 0,
          "zoomable": false
        },
        "categoryAxis": {
          "gridPosition": "start",
          "gridAlpha": 0,
          "tickPosition": "start",
          "tickLength": 20,
          "labelRotation": 45
        }
      });
    }
  }
}
</script>