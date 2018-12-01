# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Entry, type: :model do
  describe 'attributes' do
    it do
      is_expected.to respond_to(:id)
      is_expected.to respond_to(:made_at)
      is_expected.to respond_to(:description)
      is_expected.to respond_to(:type)
      is_expected.to respond_to(:category)
      is_expected.to respond_to(:user_id)
    end
  end
end
