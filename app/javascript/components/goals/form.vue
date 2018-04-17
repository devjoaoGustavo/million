<template>
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
            <input type="number" min="0.00" step="0.01" name="amount" placeholder="Valor" class="ls-field ls-mask-money" v-model="amount" required>
            <small class="ls-label-info">Qual o valor total do seu objetivo?</small>
          </label>
          <label class="ls-label col-md-3 col-xs-12">
            <b class="ls-label-text ls-hidden-accessible">Prazo</b>
            <input type="date" name="deadline" v-model="deadline" placeholder="dd/mm/aaaa" required>
            <small class="ls-label-info">Quando você irá realizá-lo?</small>
          </label>
          <label class="ls-label col-md-4 col-xs-12">
            <a href="#" class="ls-btn ls-btn-primary" @click="saveGoal()">Salvar</a>
            <a href="#" class="ls-btn ls-btn-danger" @click="clear()">Limpar</a>
          </label>
        </form>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    userid: String,
    token:  String,
    goal:   Object
  },
  data: function() {
    return {
      authenticity_token: this.$props.token,
      id: '',
      title: '',
      amount: '',
      deadline: '',
      description: ''
    }
  },
  beforeMount: function() {
    if (this.goal) {
      this.id = this.goal.id
      this.title = this.goal.title
      this.amount = this.goal.amount
      this.deadline = this.goal.deadline
      this.description = this.goal.description
    }
  },
  methods: {
    saveGoal: function() {
      var path = ''
      var meth = ''
      if (this.id) {
        path = "/api/goals/" + this.id
        meth = "PUT"
      } else {
        path = "/api/users/" + this.userid + "/goals"
        meth = "POST"
      }
      $.ajax({
        url:     path,
        method:  meth,
        data:    this.$data,
        success: (res) => {
          res['addValue'] = true
          var evt = meth == "POST" ? "created" : "updated"
          this.$emit(evt, res)

          if (meth == "POST") {
            this.clear()
          } else {
            this.title       = res.title
            this.amount      = res.amount
            this.deadline    = res.deadline
            this.description = res.description
          }
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
    }
  }
}
</script>
