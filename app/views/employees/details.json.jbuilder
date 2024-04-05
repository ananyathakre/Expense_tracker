json.extract! @employee, :id, :name, :email, :department, :emp_status, :admin_status
json.expense_reports(@employee.expense_reports) do |expense_report|
  json.title expense_report.title
  json.expenses(expense_report.expenses) do |expense|
    json.invoice_number expense.invoice_no
    json.description expense.description
    json.amount expense.amount
    json.approval_status expense.approval_status
    json.comments(expense.comments) do |comment|
      json.description comment.content
      json.replies(comment.replies) do |reply|
        json.description reply.content
      end
    end
  end
end
