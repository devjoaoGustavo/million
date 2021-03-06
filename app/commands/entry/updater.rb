# frozen_string_literal: true

class Entry < ApplicationRecord
  class Updater
    def call(params = {})
      update_entry(params)
    end

    private

    def update_entry(params)
      return @entry.reload if update!(params)
      @entry
    end

    def update!(params)
      @entry = find_entry(params)
      @entry.update_attributes(
        category_id: params[:category_id],
        description: params[:description],
        amount:      params[:amount],
        entry_date:  params[:entry_date],
        goal_id:     params[:goal_id]
      )
    end

    def find_entry(params)
      @entry = Entry.find_by(id: params[:id])
    end
  end
end
