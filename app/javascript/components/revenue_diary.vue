<template>
  <div id="revenue_diary" v-on="makeChart()" v-bind:style="'width: 100%; ' + 'height: ' + params.height + 'px;'"></div>
</template>

<script>
export default {
  props: {
    params: Object,
    data: Array
  },
  methods: {
    makeChart: function() {
      AmCharts.makeChart("revenue_diary", {
        "type":          "serial",
        "theme":         "light",
        "categoryField": "date",
        "dataProvider":  this.$props.data,
        "valueAxes": [ {
          "gridColor": "#FFFFFF",
          "gridAlpha": 0.2,
          "dashLength": 0
        } ],
        "gripAboveGraphs": true,
        "startDuration": 1,
        "graphs":        [
          {
            "balloonText": "[[date]]: <b>[[revenue]]</b>",
            "fillAlphas": 0.8,
            "lineAlpha": 0.2,
            "type":       "column",
            "valueField": "revenue"
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
