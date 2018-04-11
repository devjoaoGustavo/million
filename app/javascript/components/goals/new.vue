<template>
  <div data-ls-module="collapse" class="ls-collapse ls-md-margin-bottom" data-target="#new-goal-div">
    <a href="#" class="ls-collapse-header">
      <h2 class="ls-collapse-title ls-sm-margin-bottom">Novo objetivo</h2>
      <p>Alcance seus sonhos, desafie-se, ouse.</p>
    </a>
    <div id="new-goal-div" class="ls-collapse-body">
      <div class="ls-box-filter">
        <div class="row">
          <div class="col-md-12 col-xs-12">
            <form class="ls-form ls-form-horizontal" @submit.prevent="">
              <label class="ls-label col-md-3 col-xs-12">
                <b class="ls-label-text ls-hidden-accessible">Título</b>
                <input type="text" name="title" placeholder="Título" class="ls-field" v-model="title" required>
                <small class="ls-label-info">O que você deseja alcançar?</small>
              </label>
              <label class="ls-label col-md-3 col-xs-12">
                <b class="ls-label-text ls-hidden-accessible">Descrição</b>
                <input type="text" name="description" placeholder="Descrição" class="ls-field" v-model="description">
                <small class="ls-label-info">Escreva algo que te motive a realizá-lo</small>
              </label>
              <label class="ls-label col-md-3 col-xs-12">
                <b class="ls-label-text ls-hidden-accessible">Valor</b>
                <input type="text" name="amount" placeholder="Valor" class="ls-field ls-mask-money" v-model="amount" required>
                <small class="ls-label-info">Qual o valor total do seu objetivo?</small>
              </label>
              <label class="ls-label col-md-3 col-xs-12">
                <div class="ls-prefix-group">
                  <b class="ls-label-text ls-hidden-accessible">Prazo</b>
                  <input id="deadline-field" type="text" name="deadline" placeholder="ex.: 04/03/2018" class="datepicker" v-model="deadline" @focus="updateDeadline($event)" required>
                  <a href="#" class="ls-label-text-prefix ls-ico-calendar" data-trigger-calendar="#deadline-field"></a>
                </div>
                <small class="ls-label-info">Quando você irá realizá-lo?</small>
              </label>
              <label class="ls-label col-md-4 col-xs-12">
                <a href="#" class="ls-btn ls-btn-primary" @click="createGoal()">Salvar</a>
                <a href="#" class="ls-btn ls-btn-danger" @click="clear()">Limpar</a>
              </label>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['userId', 'apiToken'],
  data: function() {
    return {
      authenticity_token: this.$props.apiToken,
      title: '',
      description: '',
      amount: '',
      deadline: ''
    }
  },
  methods: {
    createGoal: function() {
      var path = '/api/users/' + this.$props.userId + '/goals'
      $.ajax({
        url:     path,
        method:  'POST',
        data:    this.$data,
        success: (res) => {
          res['addValue'] = true
          this.$emit('goalCreated', res)
          this.clear()
        },
        error: (res) => {
          console.error(res)
        }
      })
    },
    clear: function() {
      this.title       = ''
      this.amount      = ''
      this.deadline    = ''
      this.description = ''
    },
    updateDeadline: function(evt) {
      this.deadline = evt.target.value
    }
  }
}
</script>
