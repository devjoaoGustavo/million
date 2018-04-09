class Entry < ApplicationRecord
  class Finder
    include Rails.application.routes.url_helpers

    def call(params = {})
      build_response(list(params)).tap do |list|
        Rails.logger.info(list)
      end
    end

    private

    def list(params)
      if params[:goal_id].present?
        goal = Goal.find(params[:goal_id])
        goal.expenses.order(entry_date: :desc)
      end
    end

    def build_response(entries)
      entries.map do |entry|
        {
          id: entry.id,
          type: entry.type,
          amount: entry.amount,
          entry_date: entry.entry_date,
          description: entry.description,
          category_name: entry.category.name,
          installment_label: entry.installment_label,
          show_path: entry_path(entry),
          edit_path: edit_entry_path(entry),
          delete_all: delete_entry_path(entry, mode: 'all'),
          delete_forward: delete_entry_path(entry, mode: 'forward'),
        }
      end
    end
  end
end
