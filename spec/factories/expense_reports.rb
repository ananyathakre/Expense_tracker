# spec/factories/expense_reports.rb
FactoryBot.define do
    factory :expense_report do
      title { "Expense Report Title" }
      employee
      report_status { "pending" }
    end
  end
