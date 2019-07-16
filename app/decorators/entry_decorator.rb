# frozen_string_literal: true

class EntryDecorator < ApplicationDecorator
  delegate_all

  def entry_date
    super.strftime('%d/%m/%Y')
  end

  def presentation_name
    if description.blank?
      "#{category.name} em #{wallet.name}"
    else
      "#{description} em #{wallet.name}"
    end
  end
end
