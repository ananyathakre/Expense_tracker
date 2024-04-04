class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.date :date
      t.string :description
      t.decimal :amount
      t.integer :invoice_no
      t.string :approval_status
      t.references :expense_report, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
