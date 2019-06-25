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
        type:        class_type(params[:type]),
        wallet_id:   params[:wallet_id],
        category_id: params[:category_id],
        description: params[:description],
        entry_date:  entry_date(Hash(params).symbolize_keys),
        entry_id:    params[:entry_id],
        goal_id:     params[:goal_id],
        amount:      parse_amount(params[:amount]),
      ).tap do |previous_entry|
        create!(
          params
          .merge(entry_date: next_entry_date(previous_entry.entry_date))
          .merge(entry_id: previous_entry.id)
        )
      end
    end

    def class_type(type)
      "Entry::#{type.capitalize}"
    end

    def count(n)
      @count ||= n.zero? ? 1 : (n > MAX_INSTALLMENTS ? MAX_INSTALLMENTS : n)
    end

    def entry_date(entry_date:, **)
      return if entry_date.blank?
      Date.parse(entry_date, 'D/M/Y')
    end

    def parse_amount(input)
      BigDecimal(input).to_f
    rescue
      raise ::InvalidCurrencyFormat
    end

    def next_entry_date(date)
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
