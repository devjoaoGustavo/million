<template>
  <div data-ls-module="progressBar" role="progressbar" :aria-valuenow="valuenow | fixed"></div>
</template>

<script>
export default {
  props: ['valuenow', 'addValue'],
  filters: {
    fixed: function(value) {
      return value.toFixed(2);
    }
  },
  mounted: function() {
    if (this.$props.addValue) {
      var el = this.$el
      var percentage = $(el).attr("aria-valuenow");
      $(el).append("<span aria-valuenow='"+percentage+"%'>");
      var $bar = $(el).find('span');
      this.setProgressBarValue($bar, percentage);
    }
  },
  methods: {
    setProgressBarValue: function(target, percentage) {
      $(target).css("width", percentage+"%");
    }
  }
}
</script>
