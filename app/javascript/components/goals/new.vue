<template>
  <div data-ls-module="collapse" class="ls-collapse ls-md-margin-bottom" data-target="#new-goal-div">
    <a href="#" class="ls-collapse-header">
      <h2 class="ls-collapse-title ls-sm-margin-bottom">Novo objetivo</h2>
      <p>Alcance seus sonhos, desafie-se, ouse.</p>
    </a>
    <div id="new-goal-div" class="ls-collapse-body">
      <goal-form :userid="userid" :token="token" @created="sendCreated($event)"></goal-form>
    </div>
  </div>
</template>

<script>
import Form from './form.vue'

export default {
  props: ['userid', 'token'],
  methods: {
    sendCreated: function(evt) {
      this.$emit('goalCreated', evt)
    }
  },
  components: {
    'goal-form': Form
  }
}
</script>
