# frozen_string_literal: true

class EntryTag < ApplicationRecord
  self.table_name = 'entries_tags'
  belongs_to :entry
  belongs_to :tag
end
