# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :entries_tags, class_name: EntryTag.to_s
  has_many :entries, through: :entries_tags
end
