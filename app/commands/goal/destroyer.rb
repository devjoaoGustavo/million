# frozen_string_literal: true

class Goal < ApplicationRecord
  class Destroyer
    def call(params = {})
      Goal.transaction do
        clear_entries_with_goal_id(params[:goal_id])
        Goal
          .find(params[:goal_id])
          .destroy
      end
    end

    private

    def clear_entries_with_goal_id(id)
      Entry::Expense.where(goal_id: id).each do |entry|
        entry.goal_id = nil
        entry.save
      end
    end
  end
end
