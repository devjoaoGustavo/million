# frozen_string_literal: true

class GoalsController < ApplicationController
  def edit
    @goal = finder.call(goal_id: params[:id]).first
    @goal.merge!(deadline: Date.parse(@goal[:deadline]).strftime('%d/%m/%Y'))
    intro(message: 'Editar objetivo', ico_class: 'ls-ico-trophy', href: user_goals_path(current_user))
  end

  def index
    intro(message: 'Objetivos', ico_class: 'ls-ico-trophy', href: dashboard_path(current_user))
    @options = { id: 'goal-list', userId: current_user.id, apiToken: form_authenticity_token }.to_json
  end

  def show
    @goal = finder.call(goal_id: params[:id]).first
    intro(message: @goal[:title], ico_class: 'ls-ico-trophy', href: user_goals_path(current_user))
  end

  def destroy
    destroyer.call(goal_id: params[:id])
    redirect_to user_goals_path(current_user.id)
  end

  private

  def intro(message:, ico_class:, href:)
    @intro = { message: message, icoClass: ico_class, href: href }.to_json
  end

  def finder
    Goal::Finder.new
  end

  def destroyer
    Goal::Destroyer.new
  end
end
