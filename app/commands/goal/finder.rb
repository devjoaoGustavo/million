# frozen_string_literal: true

class Goal < ApplicationRecord
  class Finder
    include Rails.application.routes.url_helpers

    # List goals of a given user
    def call(params = {})
      build_response(list(params)).tap do |list|
        Rails.logger.info list
      end
    end

    private

    def list(params)
      if params[:goal_id].present?
        [
          Goal.find(params[:goal_id])
        ].compact
      else
        User.find(params[:user_id])
          .goals
          .where
          .not(status: :inactive)
      end
    end

    def build_response(goals)
      goals.map do |goal|
        {
          id:          goal.id,
          title:       goal.title,
          amount:      goal.amount,
          description: goal.description,
          deadline:    goal.deadline.strftime('%Y-%m-%d'),
          reached:     ((goal.expenses.sum(&:amount) / goal.amount) * 100).to_f,
          show_path:   goal_path(goal)
        }
      end
    end
  end
end
