# frozen_string_liter: true

module Api
  class EntriesController < ApplicationController
    def list
      result = finder.call(find_params)
      render json: result, status: :ok
    end

    private

    def find_params
      params.permit(:goal_id, :type)
    end

    def finder
      Entry::Finder.new
    end
  end
end
