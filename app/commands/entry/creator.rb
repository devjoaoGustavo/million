class Entry < ApplicationRecord
  class Creator
    def call(params = {})
      Entry.transaction do
        create!(params)
      end
    end

    private

    MAX_INSTALLMENTS = 720
    PERIODICITY      = 'month'

    def create!(params)
      return if count(params[:installments].to_i).zero?
      @count -= 1
      Entry.create(
        type:        params[:type],
        user_id:     params[:user_id],
        sub_category_id: params[:sub_category_id],
        description: params[:description],
        made_at:     made_at(Hash(params).symbolize_keys),
        entry_id:    params[:entry_id],
        goal_id:     params[:goal_id],
        amount:      parse_amount(params[:amount]),
      ).tap do |previous_entry|
        create!(
          params
          .merge(made_at: next_made_at(previous_entry.made_at))
          .merge(entry_id: previous_entry.id)
        )
      end
    end

    def count(n)
      @count ||= n.zero? ? 1 : (n > MAX_INSTALLMENTS ? MAX_INSTALLMENTS : n)
    end

    def made_at(made_at:, **)
      return if made_at.blank?
      Date.parse(made_at, 'D/M/Y')
    end

    def parse_amount(input)
      BigDecimal(input).to_f
    rescue
      raise ::InvalidCurrencyFormat
    end

    def next_made_at(date)
      current = parse_date(date)
      (current + 1.send(PERIODICITY)).strftime('%Y-%m-%d')
    end

    def parse_date(date)
      Date.parse(date)
    rescue
      Date.today
    end
  end
end
