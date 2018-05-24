<template>
  <v-flex xs12>
    <v-card>
      <v-dialog v-model="dialog" max-width="500px">
        <v-card>
          <v-card-title>
            <span class="headline">Editar entrada</span>
          </v-card-title>
          <v-card-text>
            <v-container grid-list-md>
              <v-layout wrap>
                <v-flex xs12 sm6>
                  <v-select
                    :items="categories"
                    item-text="name"
                    item-value="id"
                    v-model="editedItem.category_id"
                    label="Envelope"
                    single-line
                    auto
                    chips
                    prepend-icon="mail_outline"
                    hide-details required>
                  </v-select>
                </v-flex>
                <v-flex xs12 sm6>
                  <v-text-field
                    prepend-icon="R$"
                    label="Valor"
                    v-model="editedItem.amount"
                    type="number"
                    min="0.00"
                    step="0.01" required>
                  </v-text-field>
                </v-flex>
                <v-flex xs12 sm6>
                  <v-text-field v-model="editedItem.description" label="Descrição"></v-text-field>
                </v-flex>
                <v-flex xs12 sm6>
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
                    :return-value.sync="editedItem.entry_date">
                    <v-text-field type="date" slot="activator" label="Data" v-model="editedItem.entry_date" prepend-icon="event" readonly></v-text-field>
                    <v-date-picker locale="pt-br" v-model="editedItem.entry_date" @input="$refs.menu1.save(editedItem.entry_date)"></v-date-picker>
                  </v-menu>
                </v-flex>
                <v-flex v-if="entrytype == 'expense' && goals.length > 0" xs12 sm6>
                  <v-select
                    :items="goals"
                    item-text="title"
                    item-value="id"
                    v-model="editedItem.goal_id"
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
            <v-spacer></v-spacer>
            <v-btn color="error" flat @click.native="close">Cancelar</v-btn>
            <v-btn color="primary" flat @click.native="save">Salvar</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
      <v-card-title>
        {{ title }}
        <v-spacer></v-spacer>
        <v-text-field
          v-model="search"
          append-icon="search"
          label="Pesquisar"
          single-line
          hide-details
          ></v-text-field>
      </v-card-title>
      <v-data-table
        :headers="headers"
        :items="entries"
        :search="search"
        :rows-per-page-items="pagination"
        rows-per-page-text="Linhas por página:"
        :disable-initial-sort="true"
        :custom-sort="sort"
        >
        <template slot="items" slot-scope="props">
          <td>{{ props.item.category_name }}</td>
          <td class="text-xs-center">{{ props.item.description }}</td>
          <td class="text-xs-center">
            <v-badge right v-if="props.item.installment_label">
              <span slot="badge" class="caption">{{ props.item.installment_label }}</span>
              {{ props.item.amount | decimal }}
            </v-badge>
            <template v-else>{{ props.item.amount | decimal }}</template>
          </td>
          <td class="text-xs-center">{{ props.item.entry_date | formatDate }}</td>
          <td class="justify-center layout px-0">
            <v-btn icon class="mx-0" @click="editItem(props.item)">
              <v-icon color="teal">edit</v-icon>
            </v-btn>
            <v-btn icon class="mx-0" @click="deleteItem(props.item)">
              <v-icon color="pink">delete</v-icon>
            </v-btn>
          </td>
        </template>
        <v-alert slot="no-results" :value="true" color="error" icon="warning">
          Sua pesquisa por "{{ search }}" não retornou nenhum resultado.
        </v-alert>
      </v-data-table>
    </v-card>
  </v-flex>
</template>

<script>
export default {
  props: ['userid', 'entrytype', 'token'],
  data () {
    return {
      search: '',
      dialog: false,
      menu1: false,
      pagination: [5,10,25,{"text": "Todas", "value": -1}],
      headers: [
        {
          text: 'Envelope (Categoria da entrada)',
          align: 'left',
          sortable: false,
          value: 'category_name'
        },
        { text: 'Descrição', value: 'description', sortable: false },
        { text: 'Valor (R$)', value: 'amount', sortable: false },
        { text: 'Data', value: 'entry_date' },
        { text: 'Ações', value: 'category_name', sortable: false }
      ],
      entries: [],
      editedIndex: -1,
      editedItem: {
        id: '',
        category_id: '',
        description: '',
        amount: '',
        entry_date: '',
        goal_id: ''
      },
      defaultItem: {
        id: '',
        category_id: '',
        description: '',
        amount: '',
        entry_date: '',
        goal_id: ''
      },
      categories: [],
      goals: []
    }
  },
  computed: {
    title: function() {
      return this.entrytype == 'expense' ? 'Despesas' : 'Receitas'
    }
  },
  watch: {
    dialog (val) {
      val || this.close()
    }
  },
  created: function() {
    var path = '/api/users/' + this.userid + '/entries/' + this.entrytype
    $.get(path, (res) => { this.entries = res })
  },
  beforeMount: function() {
    var path = '/api/categories'
    $.get(path, (res) => { this.categories = res })

    path = '/api/users/' + this.userid + '/goals'
    $.get(path, (res) => { this.goals = res })
  },
  methods: {
    close () {
      this.dialog = false
      setTimeout(() => {
        this.editedItem  = Object.assign({}, this.defaultItem)
        this.editedIndex = -1
      }, 300)
    },
    editItem (item) {
      this.editedIndex = this.entries.indexOf(item)
      this.editedItem  = Object.assign({}, item)
      this.dialog      = true
    },
    deleteItem (item) {
      const index = this.entries.indexOf(item)
      if (confirm('Tem certeza de que deseja apagar este lançamento?')) {
        var path = '/api/users/' + this.userid + '/entries/' + item.id
        $.ajax({
          url: path,
          method: 'DELETE',
          data: { authenticity_token: this.token },
          success: (res) => {
            this.entries.splice(index, 1)
            this.$emit('success')
          },
          error: (res) => { this.$emit('failure') }
        })
      }
    },
    save () {
      var path = '/api/users/' + this.userid + '/entries/' + this.editedItem.id
      var input = {
        id:                 this.editedItem.id,
        category_id:        this.editedItem.category_id,
        description:        this.editedItem.description,
        amount:             this.editedItem.amount,
        entry_date:         this.editedItem.entry_date,
        goal_id:            this.editedItem.goal_id,
        authenticity_token: this.token,
      }
      $.ajax({
        url: path,
        method: 'PUT',
        data: input,
        success: (res) => {
          Object.assign(this.entries[this.editedIndex], this.editedItem)
          this.$emit('success')
          this.close()
        },
        error: (res) => { this.$emit('failure') }
      })
    },
    sort (items, index, isDescending) {
      return items.sort((left, right) => {
        if (isDescending) {
          return new Date(left.entry_date) - new Date(right.entry_date)
        } else {
          return new Date(right.entry_date) - new Date(left.entry_date)
        }
      })
    }
  }
}
</script>
