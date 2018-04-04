# frozen_string_literal: true

class GoalsController < ApplicationController
  def index
    intro(message:  'Bora ficar rico, meu povo!',
          ico_class: 'ls-ico-trophy',
          href:     dashboard_path(current_user))
  end

  private

  def intro(message:, ico_class:, href:)
    @intro = { message: message, icoClass: ico_class, href: href }.to_json
  end
end
