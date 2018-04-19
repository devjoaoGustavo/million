<template>
  <a :href="params.href || '#'">
    <div v-if="params.message != '' || params.message != null">
      <h1 class="ls-title-intro" :class="params.icoClass">{{ params.message || message }}</h1>
    </div>
  </a>
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
