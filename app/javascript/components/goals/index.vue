<template>
  <ul class="ls-no-list-style">
    <li v-for="goal in goals" v-bind:id="goal.id" class="ls-list">
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
          <strong>{{ goal.deadline }}</strong>
        </div>
        <div class="col-xs-12 col-md-2">
          <span class="ls-list-label">Valor estabelecido</span>
          <strong>{{ goal.amount }}</strong>
        </div>
        <div class="col-xs-12 col-md-8">
          <span class="ls-list-label">Progresso</span>
          <div data-ls-module="progressBar" role="progressbar" v-bind:aria-valuenow="goal.reached" class="ls-animated"></div>
        </div>
      </div>
    </li>
  </ul>
</template>
<script>
export default {
  props: {
    options: Object
  },
  data: function() {
    return {
      userId: this.$props.options.userId,
      goals: []
    }
  },
  mounted: function() {
    var that = this;
    $.get('/api/users/'+this.$data.userId+'/goals', function(response) {
      response.forEach(function(x) { that.$data.goals.push(x) });
    });
  }
}
</script>
