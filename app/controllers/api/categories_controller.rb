# frozen_string_literal: true

module Api
  class CategoriesController < ApplicationController
    def index
      result = Category.ordered
      render json: result, status: :ok
    end
  end
end
