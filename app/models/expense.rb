class Expense < ApplicationRecord
  belongs_to :employee
  belongs_to :expense_report
  has_many :comments, dependent: :destroy
end
