# spec/models/comment_spec.rb

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:employee) { Employee.create(name: "John Doe", email: "john@example.com") }
  let(:expense_report) { ExpenseReport.create(title: "Expense Report", employee: employee) }
  let(:expense) { Expense.create(amount: 100, invoice_no: 12345, expense_report: expense_report) }

  it "is valid with valid attributes" do
    comment = Comment.new(content: "Test comment", expense: expense)
    expect(comment).to be_valid
  end

  it "is not valid without content" do
    comment = Comment.new(expense: expense)
    expect(comment).not_to be_valid
  end

  it "belongs to an expense" do
    association = Comment.reflect_on_association(:expense)
    expect(association.macro).to eq :belongs_to
  end

  it "has many replies" do
    association = Comment.reflect_on_association(:replies)
    expect(association.macro).to eq :has_many
  end

  it "destroys associated replies when destroyed" do
    comment = Comment.create(content: "Test comment", expense: expense)
    reply = Reply.create(content: "Test reply", comment: comment)
    comment.destroy
    expect(Reply.exists?(reply.id)).to be_falsey
  end
end
