# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    intro(message: 'Objetivos', ico_class: 'ls-ico-trophy', href: dashboard_path(current_user))
    @options = { id: 'goal-list', userId: current_user.id, apiToken: form_authenticity_token }.to_json
  end

  def show
    @goal = finder.call(goal_id: params[:id]).first
    intro(message: @goal[:title], ico_class: 'ls-ico-trophy', href: user_goals_path(current_user))
  end

  private

  def intro(message:, ico_class:, href:)
    @intro = { message: message, icoClass: ico_class, href: href }.to_json
  end

  def finder
    Goal::Finder.new
  end
end
