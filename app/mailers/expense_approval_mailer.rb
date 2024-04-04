class ExpenseApprovalMailer < ApplicationMailer
    def expense_approved(employee_email, expense)
        @expense = expense
        mail(to: employee_email, subject: 'Expense Approved')
    end
end
