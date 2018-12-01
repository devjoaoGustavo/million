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
          .order(deadline: :asc)
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
          reached:     reached(goal),
          show_path:   goal_path(goal),
          edit_path:   edit_goal_path(goal),
          delete_path: goal_path(goal)
        }
      end
    end

    def reached(goal)
      ((goal
        .expenses
        .where('made_at <= ?', Time.current.at_end_of_day.utc)
        .sum(&:amount) / goal.amount) * 100).to_f
    end
  end
end
