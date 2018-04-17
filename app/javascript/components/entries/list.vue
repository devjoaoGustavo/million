<template>
  <div v-if="entries.length > 0">
    <table class="ls-table ls-table-striped ls-table-bordered ls-sm-space ls-bg-header">
      <thead>
        <tr>
          <th class="ls-ico-envelop ls-txt-center hidden-xs">Envelope</th>
          <th class="ls-ico-pencil2 ls-txt-center ls-no-padding-left ls-no-padding-right">Descrição</th>
          <th class="ls-ico-origins ls-txt-center">Valor</th>
          <th class="ls-ico-calendar ls-txt-center">Data</th>
          <th class="ls-ico-menu ls-txt-center hidden-xs">Ações</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for=" entry in entries">
          <td class="ls-txt-center hidden-xs">{{ entry.category_name }}</td>
          <td class="ls-txt-center">{{ entry.description }}</td>
          <td class="ls-txt-center">
            <a :href="entry.show_path" class="ls-tooltip-top" :aria-label="entryType(entry.type)">
              {{ entry.amount | currency }}
              <span v-if="entry.installment_label" class="ls-tag">{{ entry.installment_label }}</span>
            </a>
          </td>
          <td class="ls-txt-center">{{ entry.entry_date | formatDate }}</td>
          <td class="ls-txt-center hidden-xs">
            <a :href="entry.edit_path" class="ls-btn-sm ls-ico-cog"></a>
            <a href="#"
              class="ls-btn-sm ls-btn-primary-danger ls-ico-remove"
              data-custom-class="ls-color-danger"
              data-title="Confirmar deleção?"
              :data-content="'<ul class=\'ls-no-list-style\'> \
                <li><a :href=\''+entry.delete_path+'\' class=\'ls-btn-xs ls-btn-danger\' method=\'delete\'>Confirmar</a></li> \
                <div v-if=\''+entry.installments+'\'> \
                  <hr class=\'ls-xs-margin-bottom ls-sm-margin-top\'> \
                  <li class=\'ls-title-6\'>E as demais parcelas?</li> \
                  <hr class=\'ls-xs-margin-top ls-xs-margin-bottom\'> \
                  <li><a :href=\''+entry.delete_forward+'\' class=\'ls-btn-xs ls-btn-danger\' method=\'delete\'>Apagar próximas</a><br></li> \
                  <li><a :href=\''+entry.delete_all+'\' class=\'ls-btn-xs ls-btn-primary-danger\' method=\'delete\'>Apagar todas</a></Li> \
                </div> \
              </ul>'"
              data-ls-module="popover"
              data-placement="left"></a>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
  <div v-else>
    <div class="ls-box-group ls-md-margin-top">
      <div class="ls-box ls-box-gray ls-md-space">
        <div class="row">
          <div class="col-md-2 ls-txt-center">
            <span v-if="type == 'expense'" class="ls-ico-alone ls-ico-cart"></span>
            <span v-else class="ls-ico-alone ls-ico-chart-bar-up"></span>
          </div>
          <div class="col-md-10">
            <h3 class="ls-title-3"><strong>{{ type == 'expense' ? 'Você ainda não tem despesas aqui.' : 'Você ainda não tem receitas aqui.' }}</strong></h3>
            <p>Você pode lançar suas entradas através do menu lateral.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ['goalId', 'type'],
  data: function() {
    return {
      entries: []
    }
  },
  mounted: function() {
    var path = '/api/goals/' + this.$props.goalId + '/expenses'
    $.get(path, (res) => {
      console.log(res)
      this.entries = res
    })
  },
  methods: {
    entryType: function(type) {
      return 'Ver detalhes da ' + (type == 'Entry::Expense' ? 'despesa' : 'receita')
    }
  }
}
</script>
