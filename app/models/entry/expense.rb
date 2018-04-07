class Entry
  class Expense < Entry
    def goal
      Goal.find_by(id: goal_id)
    end
  end
end
