# frozen_string_literal: true

class EntryDecorator < ApplicationDecorator
  delegate_all

  def made_at
    super.strftime('%d/%m/%Y')
  end
end
