<template>
  <div>
    <new-goal :userId="userId" :apiToken="apiToken" @goalCreated="addGoal($event)"></new-goal>
    <div v-for="goal in orderedGoals">
      <goal :goal="goal"></goal>
    </div>
  </div>
</template>

<script>
import NewGoal from './new.vue'
import Goal from './goal.vue'

export default {
  props: {
    options: Object
  },
  data: function() {
    return {
      userId: this.$props.options.userId,
      apiToken: this.$props.options.apiToken,
      goals:  []
    }
  },
  computed: {
    orderedGoals: function() {
      return this.goals.sort((left, right) => {
        return new Date(left.deadline) - new Date(right.deadline)
      })
    }
  },
  methods: {
    addGoal: function(goal) {
      this.$data.goals.push(goal)
    }
  },
  mounted: function() {
    var that = this;
    var path = '/api/users/' + this.$data.userId + '/goals'
    $.get(path, (res) => { that.goals = res });
  },
  components: {
    'new-goal':     NewGoal,
    'goal':         Goal
  }
}
</script>
