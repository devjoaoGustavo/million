class AddGoalReferenceToEntry < ActiveRecord::Migration[5.1]
  def change
    add_reference :entries, :goal, type: :uuid
  end
end
