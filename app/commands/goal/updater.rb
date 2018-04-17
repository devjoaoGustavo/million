# frozen_string_literal: true

class Goal < ApplicationRecord
  class Updater
    def call(params = {})
      update(params)
      goal.errors.present? ? respond_failure : response_success
    end

    private

    attr_reader :goal

    def update(params)
      @goal = Goal.find(params[:id])
      goal.update_attributes(
        title:       params[:title],
        amount:      params[:amount],
        deadline:    params[:deadline],
        description: params[:description]
      )
    end

    def response_success
      {
        id: goal.id,
        title: goal.title,
        amount: goal.amount.to_f,
        deadline: goal.deadline.strftime('%Y-%m-%d'),
        description: goal.description,
        reached: ((goal.expenses.sum(&:amount) / goal.amount) * 100).to_f
      }
    end

    def respond_failure
      respond_success.merge(errors: goal.errors.full_messages)
    end
  end
end
