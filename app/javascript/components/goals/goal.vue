<template>
  <div :id="goal.id" class="ls-list">
    <header class="ls-list-header">
      <div class="ls-list-title col-md-9">
        <a :href="goal.show_path">{{ goal.title }}</a>
        <small>{{ goal.description }}</small>
      </div>
      <div class="col-md-3 ls-txt-right">
        <a :href="goal.show_path" class="ls-btn-primary">Acompanhar</a>
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
</template>

<script>
import ProgressBar from '../progress.vue'

export default {
  props: {
    goal: Object
  },
  components: {
    'progress-bar': ProgressBar,
  }
}
</script>
