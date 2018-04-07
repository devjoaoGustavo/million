<template>
  <div>
    <new-goal :userId="userId" :apiToken="apiToken" @goalCreated="addGoal($event)"></new-goal>
    <div v-for="goal in orderedGoals" :id="goal.id" class="ls-list">
      <header class="ls-list-header">
        <div class="ls-list-title col-md-9">
          <a href="#">{{ goal.title }}</a>
          <small>{{ goal.description }}</small>
        </div>
        <div class="col-md-3 ls-txt-right">
          <a href="#" class="ls-btn-primary">Acompanhar</a>
        </div>
      </header>
      <div class="ls-list-content">
        <div class="col-xs-12 col-md-2">
          <span class="ls-list-label">Vencimento</span>
          <strong>{{ goal.deadline | formatDate }}</strong>
        </div>
        <div class="col-xs-12 col-md-2">
          <span class="ls-list-label">Valor total</span>
          <strong>{{ goal.amount | currency }}</strong>
        </div>
        <div class="col-xs-12 col-md-8">
          <span class="ls-list-label">Progresso</span>
          <progress-bar :valuenow="goal.reached" :addValue="goal.addValue"></progress-bar>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import NewGoal from './new.vue'
import ProgressBar from '../progress.vue'

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
    'progress-bar': ProgressBar
  }
}
</script>
