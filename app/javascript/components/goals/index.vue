<template>
  <div>
    <new-goal
      :userid="userid"
      :token="token"
      @goalCreated="refresh($event)"></new-goal>
    <template v-if="goals.length > 0">
      <template v-for="goal in orderedGoals">
        <goal :goal="goal" :userid="options.userId" :key="goal.id"></goal>
      </template>
    </template>
    <template v-else>
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
    </template>
  </div>
</template>

<script>
import NewGoal from './new.vue'
import Goal    from './goal.vue'

export default {
  props: { options: Object },
  data: function() {
    return {
      userid:      this.options.userid,
      token:       this.options.token,
      spinnerSize: 100,
      goals:       []
    }
  },
  computed: {
    orderedGoals: function() {
      return this.goals.sort((left, right) => {
        return new Date(left.deadline) - new Date(right.deadline)
      })
    }
  },
  mounted: function() {
    this.loadGoals()
    locastyle.progressBar.init()
  },
  methods: {
    loadGoals: function(goal) {
      var that = this;
      var path = '/api/users/' + this.userid + '/goals'
      $.get(path, (res) => {
        that.goals = res
      });
    },
    refresh: function(evt) {
      this.goals.push(evt)
      window.location.reload()
    }
  },
  components: {
    'new-goal': NewGoal,
    'goal':     Goal
  }
}
</script>
