# frozen_string_literal: true

module Api
  class GoalsController < ApplicationController
    def index
      result = finder.(user_id: params[:user_id])
      render_ok(result)
    end

    def create
      result = creator.call(goal_params)
      result[:errors] ? render_precondition_failed(result) : render_ok(result)
    end

    def update
      result = updater.call(goal_params)
      result[:errors] ? render_precondition_failed(result) : render_ok(result)
    end

    def destroy
      destroyer.call(goal_id: params[:id])
      head :ok
    end

    private

    def render_ok(result)
      render json: result, status: :ok
    end

    def render_precondition_failed(result)
      render json: result, status: :precondition_failed
    end

    def finder
      Goal::Finder.new
    end

    def creator
      Goal::Creator.new
    end

    def updater
      Goal::Updater.new
    end

    def destroyer
      Goal::Destroyer.new
    end

    def goal_params
      params
        .permit(:id, :title, :description, :deadline, :amount)
        .merge(user_id: current_user.id)
    end
  end
end
