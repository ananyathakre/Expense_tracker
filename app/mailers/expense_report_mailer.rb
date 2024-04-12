# app/mailers/expense_report_mailer.rb
class ExpenseReportMailer < ApplicationMailer
    def notify_approval(employee, expense_report, applied_amount, approved_amount)
      @employee = employee
      @expense_report = expense_report
      @applied_amount = applied_amount
      @approved_amount = approved_amount
      mail(to: @employee.email, subject: 'Expense Report Approval Notification')
    end
  end
