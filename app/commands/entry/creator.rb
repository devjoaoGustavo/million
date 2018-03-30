class Entry
  class Creator
    def call(params = {})
      Entry.transaction do
        entry = create!(params)
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
        category_id: params[:category_id],
        description: params[:description],
        entry_date:  params[:entry_date],
        entry_id:    params[:entry_id],
        amount:      parse_amount(params[:amount]),
      ).tap do |previous_entry|
        create!(
          params
          .merge(entry_date: next_entry_date(params[:entry_date]))
          .merge(entry_id: previous_entry.id)
        )
      end
    end

    def count(n)
      @count ||= n.zero? ? 1 : (n > MAX_INSTALLMENTS ? MAX_INSTALLMENTS : n)
    end

    def parse_amount(input)
      BigDecimal(input.remove('.').gsub(',', '.')).to_f
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
