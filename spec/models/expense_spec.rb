# spec/models/expense_spec.rb

require 'rails_helper'

RSpec.describe Expense, type: :model do
  let(:employee) { Employee.create(name: "John Doe", email: "john@example.com") }
  let(:expense_report) { ExpenseReport.create(title: "Expense Report", employee: employee) }

  it "is valid with valid attributes" do
    expense = Expense.new(amount: 100, invoice_no: 12345, expense_report: expense_report)
    expect(expense).to be_valid
  end

  it "is not valid without an amount" do
    expense = Expense.new(invoice_no: 12345, expense_report: expense_report)
    expect(expense).not_to be_valid
  end

  it "is not valid without an invoice number" do
    expense = Expense.new(amount: 100, expense_report: expense_report)
    expect(expense).not_to be_valid
  end

  it "belongs to an expense report" do
    association = Expense.reflect_on_association(:expense_report)
    expect(association.macro).to eq :belongs_to
  end

  it "has many comments" do
    association = Expense.reflect_on_association(:comments)
    expect(association.macro).to eq :has_many
  end

  it "destroys associated comments when destroyed" do
    expense = Expense.create(amount: 100, invoice_no: 12345, expense_report: expense_report)
    comment = Comment.create(content: "Comment", expense: expense)
    expense.destroy
    expect(Comment.exists?(comment.id)).to be_falsey
  end
end
