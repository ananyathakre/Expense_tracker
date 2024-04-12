# spec/models/expense_report_spec.rb

require 'rails_helper'

RSpec.describe ExpenseReport, type: :model do
  it "is valid with valid attributes" do
    employee = Employee.create(name: "John Doe", email: "john@example.com")
    expense_report = ExpenseReport.new(title: "Expense Report", employee: employee)
    expect(expense_report).to be_valid
  end

  it "is not valid without a title" do
    employee = Employee.create(name: "John Doe", email: "john@example.com")
    expense_report = ExpenseReport.new(employee: employee)
    expect(expense_report).not_to be_valid
  end

  it "belongs to an employee" do
    association = ExpenseReport.reflect_on_association(:employee)
    expect(association.macro).to eq :belongs_to
  end

  it "has many expenses" do
    association = ExpenseReport.reflect_on_association(:expenses)
    expect(association.macro).to eq :has_many
  end

  it "destroys associated expenses when destroyed" do
    employee = Employee.create(name: "John Doe", email: "john@example.com")
    expense_report = ExpenseReport.create(title: "Expense Report", employee: employee)
    expense = Expense.create(description: "Expense", amount: 100, expense_report: expense_report)
    expense_report.destroy
    expect(Expense.exists?(expense.id)).to be_falsey
  end
end
