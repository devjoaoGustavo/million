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
      AmCharts.makeChart( this.$props.params.chartId, {
        "type": "pie",
        "theme": "light",
        "dataProvider": data,
        "valueField": "amount",
        "titleField": "category",
        "balloon": {
          "fixedPosition": true
        },
        "export": {
          "enabled": true
        }
      });
    }
  }
}
</script>