<template>
  <img :style="'width: '+Number(size)+'px; height: '+Number(size)+'px;'" src="../../assets/images/loading.svg">
</template>

<script>
import '../../assets/images/loading.svg'
export default {
  props: ['size'],
  data: function() {
    return {
    }
  }
}
</script>
