# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    intro(message: t('messages.lets_get_rich'), ico_class: 'ls-ico-trophy', href: dashboard_path(current_user))
    @options = { id: 'goal-list', userId: current_user.id, apiToken: form_authenticity_token }.to_json
  end

  private

  def intro(message:, ico_class:, href:)
    @intro = { message: message, icoClass: ico_class, href: href }.to_json
  end
end
