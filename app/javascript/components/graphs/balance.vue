<template>
  <div v-bind:id="params.chartId" v-on="makeChart(data)" v-bind:style="'width: 100%; height: ' + params.size.height + 'px;'"></div>
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
        "type": "serial",
        "theme": "light",
        "marginRight": 40,
        "marginLeft": 40,
        "autoMarginOffset": 20,
        "mouseWheelZoomEnabled": true,
        "dataDateFormat": "DD/MM/YYYY",
        "valueAxes": [{
          "id": "v1",
          "axisAlpha": 0,
          "position": "left",
          "ignoreAxisWidth": true
        }],
        "balloon": {
          "borderThickness": 1,
          "shadowAlpha": 0
        },
        "graphs": [{
          "id": "g1",
          "balloon": {
            "drop": true,
            "adjustBorderColor": false,
            "color": "#ffffff"
          },
          "bullet": "round",
          "bulletBorderAlpha": 1,
          "bulletColor": "#FFFFFF",
          "bulletSize": 5,
          "hiddeBulletCount": 50,
          "lineThickness": 2,
          "title": "red line",
          "useLineColorForBulletBorder": true,
          "valueField": "amount",
          "balloonText": "<span style='font-size: 18px;'>[[amount]]</span>",
        }],
        "chartScroolBar": {
          "chart": "g1",
          "oppositeAxis": false,
          "offset": 30,
          "scroolBarHeight": 80,
          "backgroundAlpha": 0,
          "selectedBackgroundAlpha": 0.1,
          "selectedBackgroundColor": "#888888",
          "graphFillAlpha": 0,
          "graphLineAlpha": 0.5,
          "selectedGraphFillAlpha": 0,
          "selectedGraphLineAlpha": 1,
          "autoGridCount": true,
          "color": "#AAAAAA"
        },
        "chartCursor": {
          "pan": true,
          "valueLineEnabled": true,
          "valueLineBalloonEnabled": true,
          "cursorAlpha": 1,
          "cursorColor": "#258cbb",
          "limitToGraph": "g1",
          "valueLineAlpha": 0.2,
          "valueZoomable": true
        },
        "valueScroolBar": {
          "oppositeAxis": false,
          "offset": 50,
          "scroolBarHeight": 10
        },
        "categoryField": "date",
        "categoryAxis": {
          "parseDates": false,
          "dashLength": 1,
          "minorGridEnabled": true
        },
        "export": {
          "enabled": true
        },
        "dataProvider": this.$props.data
      });
    }
  }
}
</script>