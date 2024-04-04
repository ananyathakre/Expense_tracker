class Employee < ApplicationRecord
    has_many :expense_reports, dependent: :destroy
    has_many :expenses, dependent: :destroy
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    attribute :emp_status, :string, default: "active"
    attribute :admin_status, :boolean, default: false
end
