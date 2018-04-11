<template>
  <div>
    <new-goal :userId="userId" :apiToken="apiToken" @goalCreated="addGoal($event)"></new-goal>
    <div v-if="goals.length > 0">
      <div v-for="goal in orderedGoals">
        <goal :goal="goal"></goal>
      </div>
    </div>
    <div v-else>
      <div class="ls-box-group">
        <div class="ls-box ls-box-gray ls-md-space">
          <div class="row">
            <div class="col-md-2 ls-txt-center">
              <span class="ls-ico-alone ls-ico-trophy"></span>
            </div>
            <div class="col-md-10">
              <h3 class="ls-title-3"><strong>Crie e realize seus objetivos</strong></h3>
              <p>Você pode estabelecer objetivos de qualquer valor e para qualquer data.</p>
              <p>Depois disso, basta lançar uma despesa indicando um objetivo e ele será automaticamente atualizado.</p>
            </div>
          </div>
        </div>
      </div>
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
