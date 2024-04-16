# spec/controllers/expense_reports_controller_spec.rb
require 'rails_helper'

RSpec.describe ExpenseReportsController, type: :controller do
    render_views
  describe "GET #show" do
    it "returns a success response" do
      employee = create(:employee)
      expense_report = create(:expense_report, employee: employee)
      get :show, params: { user_id: employee.id, id: expense_report.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    let(:employee) { create(:employee) }

    it "creates a new expense report with valid parameters" do
      post :create, params: { employee_id: employee.id, title: "Expense Report 1", report_status: "pending" }
      expect(response).to be_successful
      expect(ExpenseReport.count).to eq(1)
    end

    it "returns unprocessable_entity status with invalid parameters" do
      post :create, params: { employee_id: employee.id, title: "", report_status: "pending" }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

end
