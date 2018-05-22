<template>
  <div class="ls-list">
    <header class="ls-list-header">
      <div class="ls-list-title col-md-8">
        <a :href="goal.show_path">{{ goal.title }}</a>
        <small>{{ goal.description }}</small>
      </div>
      <div class="col-md-4 ls-txt-right">
        <a :href="goal.show_path" class="ls-btn-primary ls-ico-code">Mostrar</a>
        <a :href="goal.edit_path" class="ls-btn ls-ico-cog">Editar</a>
        <a href="#"
          class="ls-btn-sm ls-btn-primary-danger ls-ico-remove"
          data-custom-class="ls-color-danger"
          data-title="Confirmar deleção?"
          :data-content="'<ul class=\'ls-no-list-style\'> \
            <li><a href=\''+goal.delete_path+'\' data-method=\'delete\' class=\'ls-btn-xs ls-btn-danger\'>Confirmar</a></li> \
          </ul>'"
          data-ls-module="popover"
          data-placement="left">Apagar</a>
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
        <div data-ls-module="progressBar" role="progressbar" :aria-valuenow="goal.reached | fixed"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props:   { goal: Object },
  filters: {
    fixed: function(value) {
      return value.toFixed(2);
    }
  }
}
</script>
