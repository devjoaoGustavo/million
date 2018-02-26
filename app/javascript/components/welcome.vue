<template>
  <div v-if="params.message != '' || params.message != null">
    <h1 class="ls-title-intro ls-ico-home">{{ params.message || message }}</h1>
  </div>
</template>

<script>
  export default {
    props: {
      params: Object
    },
    data: function () {
      return {
        message: "Welcome to your personal finance manager, Million"
      }
    }
  }
</script>