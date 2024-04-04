class ExpenseRejectionMailer < ApplicationMailer
    def expense_rejected(employee_email, expense)
        @expense = expense
        mail(to: employee_email, subject: 'Expense Rejected')
    end
end
