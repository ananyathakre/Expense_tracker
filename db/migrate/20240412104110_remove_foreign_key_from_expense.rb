class RemoveForeignKeyFromExpense < ActiveRecord::Migration[7.1]
  def change
    remove_reference :expenses, :employee, foreign_key: true
  end
end