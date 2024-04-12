class Expense < ApplicationRecord
  belongs_to :expense_report
  has_many :comments, dependent: :destroy
  validates :amount, presence: true
  validates :invoice_no, presence: true
end
