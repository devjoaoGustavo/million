# frozen_string_literal: true

class Goal < ApplicationRecord
  class Finder
    # List goals of a given user
    def call(params = {})
      build_response(list(params[:user_id])).tap do |list|
        Rails.logger.info list
      end
    end

    private

    def list(user_id)
      User.find(user_id)
        .goals
        .where
        .not(status: :inactive)
    end

    def build_response(goals)
      goals.map do |goal|
        {
          title:       goal.title,
          amount:      goal.amount,
          description: goal.description,
          deadline:    goal.deadline.strftime('%Y-%m-%d'),
          reached:     ((goal.expenses.sum(&:amount) / goal.amount) * 100).to_f
        }
      end
    end
  end
end
