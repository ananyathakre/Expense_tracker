class ExpenseReport < ApplicationRecord
  belongs_to :employee
  has_many :expenses , dependent: :destroy
  validates :title, presence: true
end
