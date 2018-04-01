# frozen_string_literal: true

class HomeController < ApplicationController
  def home
    render layout: false
  end
end
