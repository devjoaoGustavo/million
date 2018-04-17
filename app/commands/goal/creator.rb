# frozen_string_literal: true

class Goal < ApplicationRecord
  class Creator
    # Create a new goal with the given params
    def call(params={})
      @goal = create(params)
      goal.persisted? ? respond_success : respond_failure
    end

    private

    attr_reader :goal

    def create(params)
      user = User.find(params.delete(:user_id))
      Goal.create(params).tap do |instance|
        user.dreams.create(goal: instance)
      end
    end

    def respond_success
      {
        title:       goal.title,
        amount:      goal.amount,
        description: goal.description,
        deadline:    goal.deadline.strftime('%Y-%m-%d'),
        reached:     ((goal.expenses.sum(&:amount) / goal.amount) * 100).to_f
      }
    end

    def respond_failure
      respond_success.merge(errors: goal.errors.full_messages)
    end
  end
end
