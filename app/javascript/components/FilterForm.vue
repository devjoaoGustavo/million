<template>
  <v-flex xs12 mb-3>
    <v-expansion-panel popout>
      <v-expansion-panel-content>
        <div slot="header" class="headline">Filtrar entradas</div>
        <v-form @submit.prevent="">
          <v-container grid-list-md>
            <v-layout row wrap>
              <v-flex xs12 md3>
                <v-select
                  :items="categories"
                  item-text="name"
                  item-value="id"
                  v-model="categoryId"
                  label="Envelope"
                  single-line
                  auto
                  hide-details>
                </v-select>
              </v-flex>
              <v-spacer></v-spacer>
              <v-spacer></v-spacer>
              <v-flex xs12 md2>
                <v-menu
                  ref="date1"
                  lazy
                  :close-on-content-click="false"
                  v-model="date1"
                  transition="scale-transition"
                  offset-y
                  :nudge-right="40"
                  min-width="290px"
                  :return-value.sync="from">
                  <v-text-field type="date" slot="activator" label="Data inicial" v-model="from" readonly></v-text-field>
                  <v-date-picker locale="pt-br" v-model="from" :max="to" @input="$refs.date1.save(from)"></v-date-picker>
                </v-menu>
              </v-flex>
              <v-flex xs12 md2>
                <v-menu
                  ref="date2"
                  lazy
                  :close-on-content-click="false"
                  v-model="date2"
                  transition="scale-transition"
                  offset-y
                  :nudge-right="40"
                  min-width="290px"
                  :return-value.sync="to">
                  <v-text-field type="date" slot="activator" label="Data final" v-model="to" readonly></v-text-field>
                  <v-date-picker locale="pt-br" v-model="to" :min="from" @input="$refs.date2.save(to)"></v-date-picker>
                </v-menu>
              </v-flex>
              <v-flex xs12>
                <v-btn @click="filter()" block color="primary" dark>Filtrar</v-btn>
              </v-flex>
            </v-layout>
          </v-container>
        </v-form>
      </v-expansion-panel-content>
    </v-expansion-panel>
  </v-flex>
</template>

<script>
export default {
  props: ['entrytype'],
  data: function() {
    return {
      date1: false,
      date2: false,
      from: '',
      to: '',
      categoryId: '',
      categories: []
    }
  },
  created: function() {
    var path = '/api/categories'
    $.get(path, (res) => {
      this.categories = res
    })
  },
  methods: {
    filter: function() {
      console.log("TODO: Filtar!!!")
      console.log(this.from, this.to, this.categoryId, this.entrytype)
      this.clear()
    },
    clear: function() {
      this.from = ''
      this.to = ''
      this.categoryId = ''
    }
  }
}
</script>
