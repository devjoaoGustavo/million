<template>
  <v-flex xs12>
    <v-card>
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
        >
        <template slot="items" slot-scope="props">
          <td>{{ props.item.category }}</td>
          <td class="text-xs-right">{{ props.item.description }}</td>
          <td class="text-xs-right">
            <v-badge right v-if="props.item.installment_label">
              <span slot="badge" class="caption">{{ props.item.installment_label }}</span>
              {{ props.item.amount | currency }}
            </v-badge>
            <template v-else>{{ props.item.amount | currency }}</template>
          </td>
          <td class="text-xs-right">{{ props.item.entry_date | formatDate }}</td>
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
  props: ['userid', 'entrytype'],
  data () {
    return {
      search: '',
      pagination: [5,10,25,{"text": "Todas", "value": -1}],
      headers: [
        {
          text: 'Envelope (Categoria da entrada)',
          align: 'left',
          sortable: false,
          value: 'category'
        },
        { text: 'Descrição', value: 'description', sortable: false },
        { text: 'Valor', value: 'amount', sortable: false },
        { text: 'Data', value: 'entry_date' }
      ],
      entries: []
    }
  },
  computed: {
    title: function() {
      return this.entrytype == 'expense' ? 'Despesas' : 'Receitas'
    }
  },
  created: function() {
    var path = '/api/users/' + this.userid + '/entries/' + this.entrytype
    console.log(path)
    $.get(path, (res) => { this.entries = res; console.log(this.entries) })
  }
}
</script>
