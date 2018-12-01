# frozen_string_liter: true

module Api
  class EntriesController < ApplicationController
    rescue_from InvalidCurrencyFormat, with: :invalid_currency_format

    def list
      render_json_ok(finder.call(find_params))
    end

    def entries_by_month
      render_json_ok(UserDecorator
        .decorate(current_user).entries_by_month)
    end

    def expense_by_category
      render_json_ok(UserDecorator
        .decorate(current_user).expense_by_category)
    end

    def revenue_by_category
      render_json_ok(UserDecorator
        .decorate(current_user).revenue_by_category)
    end

    def daily_balance
      render_json_ok(UserDecorator
        .decorate(current_user).balance_of_today)
    end

    def daily_expense
      render_json_ok(UserDecorator
        .decorate(current_user).expenses_of_today.sum(&:amount))
    end

    def daily_revenue
      render_json_ok(UserDecorator
        .decorate(current_user).revenues_of_today.sum(&:amount))
    end

    def weekly_balance
      render_json_ok(UserDecorator
        .decorate(current_user).balance_of_last_days(7))
    end

    def weekly_expense
      render_json_ok(UserDecorator
        .decorate(current_user).expenses_of_last_days(7).sum(&:amount))
    end

    def weekly_revenue
      render_json_ok(UserDecorator
        .decorate(current_user).revenues_of_last_days(7).sum(&:amount))
    end

    def monthly_expense
      render_json_ok(UserDecorator
        .decorate(current_user).expenses_of_this_month.sum(&:amount))
    end

    def monthly_revenue
      render_json_ok(UserDecorator
        .decorate(current_user).revenues_of_this_month.sum(&:amount))
    end

    def monthly_balance
      render_json_ok(UserDecorator.decorate(current_user).monthly_balance)
    end

    def balance
      render_json_ok(UserDecorator.decorate(current_user).balance)
    end

    def create
      result = creator.call(creation_params)
      if result.persisted?
        render_json_ok(result)
      else
        render json: result.errors.messages, status: :precondition_failed
      end
    end

    private

    def render_json_ok(result)
      render json: result, status: :ok
    end

    def find_params
      params.permit(:goal_id, :type)
    end

    def creation_params
      type = params[:type] == 'expense' ? Entry::Expense.to_s : Entry::Revenue.to_s
      params.permit(:amount,
                    :goal_id,
                    :user_id,
                    :made_at,
                    :description,
                    :category_id,
                    :installments)
        .merge(type: type)
    end

    def finder
      Entry::Finder.new
    end

    def creator
      Entry::Creator.new
    end

    def invalid_currency_format
      render json: { amount: ['valor da entrada inválido'] }, status: :precondition_failed
    end
  end
end
