# frozen_string_literal: true

module Timing
  include ActiveSupport::Concern

  def today
    Time.current.at_beginning_of_day.utc..Time.current.utc
  end

  def this_month
    Time.current.at_beginning_of_month.utc..Time.current.utc
  end

  def last_days(n)
    (Time.current.at_beginning_of_day.utc - n.days)..Time.current.at_end_of_day.utc
  end

  def this_year
    Time.current.at_beginning_of_year.utc..Time.current.at_end_of_year.utc
  end
end
