# spec/models/employee_spec.rb

require 'rails_helper'
RSpec.describe Employee, type: :model do
  it "is valid with valid attributes" do
    employee = Employee.new(name: "John Doe", email: "john@example.com")
    expect(employee).to be_valid
  end

  it "is not valid without a name" do
    employee = Employee.new(email: "john@example.com")
    expect(employee).not_to be_valid
  end

  it "is not valid without an email" do
    employee = Employee.new(name: "John Doe")
    expect(employee).not_to be_valid
  end

  it "is not valid with a duplicate email" do
    Employee.create(name: "John Doe", email: "john@example.com")
    employee = Employee.new(name: "Jane Doe", email: "john@example.com")
    expect(employee).not_to be_valid
  end

  it "has a default emp_status of 'active'" do
    employee = Employee.new(name: "John Doe", email: "john@example.com")
    expect(employee.emp_status).to eq("active")
  end

  it "has a default admin_status of false" do
    employee = Employee.new(name: "John Doe", email: "john@example.com")
    expect(employee.admin_status).to be_falsey
  end

  it "destroys associated expense_reports when destroyed" do
    employee = Employee.create(name: "John Doe", email: "john@example.com")
    expense_report = ExpenseReport.create(title: "Expense Report", employee: employee)
    employee.destroy
    expect(ExpenseReport.exists?(expense_report.id)).to be_falsey
  end
end
