<template>
  <div>
    <goal-details :goal="goal"></goal-details>
    <entries type="expense" :goalId="goal.id"></entries>
  </div>
</template>

<script>
import Entries from '../entries/list.vue'
import Goal from './goal.vue'

export default {
  props: {
    goal: Object,
  },
  components: {
    'entries':      Entries,
    'goal-details': Goal
  }
}
</script>
