# frozen_string_literal: true

class EntryDecorator < ApplicationDecorator
  delegate_all

  def entry_date
    super.strftime('%d/%m/%Y')
  end
end
