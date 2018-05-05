<template>
  <v-layout row justify-center>
    <v-dialog v-model="dialog" persistent>
      <v-btn
        color="primary"
        dark
        fab
        slot="activator">
        <div>
          <v-icon>attach_money</v-icon>
        </div>
      </v-btn>
      <v-card>
        <v-form @submit-prevent="">
          <v-card-title>
            <span class="headline">Nova entrada</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap>
                <v-flex xs12 sm12 md12>
                  <v-radio-group v-model="entrytype" row>
                    <v-radio label="Despesa" color="error" value="expense"></v-radio>
                    <v-radio label="Receita" color="success" value="revenue"></v-radio>
                  </v-radio-group>
                </v-flex>
                <v-flex xs12 sm6 md6>
                  <v-select
                    :items="categories"
                    item-text="name"
                    item-value="id"
                    v-model="categoryId"
                    label="Envelope"
                    single-line
                    auto
                    chips
                    prepend-icon="mail_outline"
                    hide-details required>
                  </v-select>
                </v-flex>
                <v-flex xs12 sm6 md6>
                  <v-text-field
                    prepend-icon="R$"
                    label="Valor"
                    v-model="amount"
                    type="number"
                    min="0.00"
                    step="0.01" required>
                  </v-text-field>
                </v-flex>
                <v-flex xs12 sm12 md12>
                  <v-text-field v-model="description" label="Descrição"></v-text-field>
                </v-flex>

                <v-flex xs12 sm6 md6>
                  <v-menu
                    ref="menu1"
                    lazy
                    :close-on-content-click="false"
                    v-model="menu1"
                    transition="scale-transition"
                    offset-y
                    full-width
                    :nudge-right="40"
                    min-width="290px"
                    :return-value.sync="entryDate">
                    <v-text-field slot="activator" label="Data" v-model="entryDate" prepend-icon="event" readonly></v-text-field>
                    <v-date-picker v-model="entryDate" @input="$refs.menu1.save(entryDate)"></v-date-picker>
                  </v-menu>
                </v-flex>

                <v-flex xs12 sm6 md6>
                  <v-badge left><span slot="badge">{{ installments }}</span></v-badge>
                  <v-slider color="primary" label="Parcelas" min="1" max="120" thumb-label v-model="installments"></v-slider>
                </v-flex>

                <v-flex v-if="entrytype == 'expense' && goals.length > 0" xs12 sm6 md6 offset-sm6 offset-md6>
                  <v-select
                    :items="goals"
                    item-text="title"
                    item-value="id"
                    v-model="goalId"
                    label="Objetivo"
                    single-line
                    auto
                    chips
                    prepend-icon="my_location"
                    hide-details required>
                  </v-select>
                </v-flex>
              </v-layout>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-btn color="primary" flat @click="saveEntry()">Salvar</v-btn>
            <v-btn flat small @click="clear()">Cancelar</v-btn>
          </v-card-actions>
        </v-form>
      </v-card>
    </v-dialog>
  </v-layout>
</template>

<script>
import Loading from '../spinner_wedges.vue'
export default {
  props: {
    options: Object
  },
  data: function() {
    return {
      categories: [],
      goals: [],
      type: this.entrytype,
      categoryId: '',
      description: '',
      amount: '',
      entryDate: '',
      entrytype: 'expense',
      goalId: '',
      installments: 1,
      loading: true,
      dialog: false,
      menu1: false
    }
  },
  beforeMount: function() {
    var path = '/api/categories'
    $.get(path, (res) => {
     this.categories = res
    })
    path = '/api/users/' + this.options.userid + '/goals'
    $.get(path, (res) => {
      this.goals   = res
      this.loading = false
    })
  },
  methods: {
    saveEntry: function() {
      var input = {
        category_id:        this.categoryId,
        description:        this.description,
        amount:             this.amount,
        entry_date:         this.entryDate,
        type:               this.entrytype,
        goal_id:            this.goalId,
        installments:       this.installments,
        authenticity_token: this.options.token
      }
      var path = '/api/users/'+this.options.userid+'/entries'
      $.ajax({
        url: path,
        method: 'POST',
        data: input,
        success: (res) => {
          this.$emit('entrycreated', res)
          this.clear()
        },
        error: (res) => {
          this.$emit('entryfailed', res)
        }
      })
    },
    clear: function() {
      this.categoryId   = ''
      this.description  = ''
      this.amount       = ''
      this.entryDate    = ''
      this.entrytype    = 'expense'
      this.goalId       = ''
      this.installments = 1
      this.dialog       = false
    },
    selectExpense: function() {
      this.entrytype = 'expense'
    },
    selectRevenue: function() {
      this.entrytype = 'revenue'
    },
    defaultDate: function() {
      var date = new Date()
      return date.getUTCFullYear() + '-' + String('00' + (date.getUTCMonth() + 1)).slice(-2) + '-' + String('00' + date.getUTCDate()).slice(-2)
    }
  },
  components: {
    'spinner': Loading
  }
}
</script>
