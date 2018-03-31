# frozen_string_literal: true

module Timing
  include ActiveSupport::Concern

  def today
    Time.current.at_beginning_of_day..Time.current.utc
  end

  def this_month
    Time.current.at_beginning_of_month..Time.current.utc
  end

  def last_days(days)
    (Time.current - days).at_beginning_of_day..Time.current.utc
  end
end
