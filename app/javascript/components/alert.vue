<template>
  <div v-if="isNotice" class="ls-alert-success  ls-dismissable">
    <span data-ls-module="dismiss" class="ls-dismiss" @click="emitEvent($event)">&times;</span>
    {{ message }}
  </div>
  <div v-else-if="isAlert" class="ls-alert-danger  ls-dismissable">
      <span data-ls-module="dismiss" class="ls-dismiss" @click="emitEvent($event)">&times;</span>
      {{ message }}
  </div>
</template>

<script>
  export default {
    props: ['isNotice', 'isAlert', 'message'],
    methods: {
      emitEvent: function(evt) {
        this.$emit('close', evt)
      }
    }
  }
</script>
