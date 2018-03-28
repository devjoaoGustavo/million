# frozen_string_literal: true

module Timing
  include ActiveSupport::Concern

  def today
    DateTime.current.at_beginning_of_day.utc..Time.current.utc
  end

  def this_month
    DateTime.current.at_beginning_of_month.utc..Time.current.utc
  end

  def last_days(days)
    (DateTime.current - days).at_beginning_of_day.utc..Time.current.utc
  end
end
