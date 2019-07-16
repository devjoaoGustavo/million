module ApplicationHelper
  def entry_form_button
    @entry.new_record? ? 'Salvar nova entrada' : 'Atualizar entrada'
  end
end
