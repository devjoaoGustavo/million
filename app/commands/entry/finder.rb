class Entry < ApplicationRecord
  class Finder
    include Rails.application.routes.url_helpers

    def call(params = {})
      if params[:goal_id].present?
        list_response(list(params))
      elsif params[:type].present? && params[:user_id].present?
        index_response(index(params))
      end
    end

    private

    def index(params)
      entries = Entry
        .where(user_id: params[:user_id], type: params[:type] == 'expense' ? 'Entry::Expense' : 'Entry::Revenue')
        .where('entry_date <= ? ', Time.current.at_end_of_day.utc)
        .order(created_at: :desc)
    end

    def index_response(entries)
      entries.map do |entry|
        {
          id:                entry.id,
          category_id:       entry.category_id,
          category_name:     entry.category.name,
          description:       entry.description,
          entry_date:        entry.entry_date.to_date,
          entry_type:        entry.expense? ? 'expense' : 'revenue',
          amount:            entry.amount,
          installment_label: entry.installment_label,
          goal_id:           entry.goal_id
        }
      end
    end

    def list(params)
        goal = Goal.find(params[:goal_id])
        goal.expenses
          .where('entry_date <= ?',
                 Time.current.at_end_of_day.utc).order(entry_date: :desc)
    end

    def list_response(entries)
      entries.map do |entry|
        {
          id:                entry.id,
          type:              entry.type,
          amount:            entry.amount,
          entry_date:        entry.entry_date,
          description:       entry.description,
          category_name:     entry.category.name,
          installment_label: entry.installment_label,
          show_path:         entry_path(entry),
          edit_path:         edit_entry_path(entry),
          delete_all:        delete_entry_path(entry, mode: 'all'),
          delete_forward:    delete_entry_path(entry, mode: 'forward'),
        }
      end
    end
  end
end
