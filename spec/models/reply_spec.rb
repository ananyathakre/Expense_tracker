# spec/models/reply_spec.rb

require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:employee) { Employee.create(name: "John Doe", email: "john@example.com") }
  let(:expense_report) { ExpenseReport.create(title: "Expense Report", employee: employee) }
  let(:expense) { Expense.create(amount: 100, invoice_no: 12345, expense_report: expense_report) }
  let(:comment) { Comment.create(content: "Test comment", expense: expense) }

  it "belongs to a comment" do
    association = Reply.reflect_on_association(:comment)
    expect(association.macro).to eq :belongs_to
  end
end
