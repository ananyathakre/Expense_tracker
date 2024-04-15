require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do
    render_views

    describe "GET #show" do
    it "returns a success response for admin" do
        admin_user = create(:employee, :admin)
        get :show, params: { user_id: admin_user.id }
        expect(response).to be_successful
    end

      it "returns a not_found response for non-existent user" do
        get :show, params: { user_id: 999 }
        expect(response).to have_http_status(:not_found)
      end
    end

    describe "POST #create" do
      it "creates a new employee with valid attributes" do
        expect {
          post :create, params: { employee: attributes_for(:employee) }
        }.to change(Employee, :count).by(1)
      end

      it "returns the created employee" do
        post :create, params: { employee: attributes_for(:employee) }
        expect(response).to have_http_status(:success)
      end

      it "returns unprocessable_entity status for invalid attributes" do
        post :create, params: { employee: { name: nil, email: 'invalid-email' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    describe "PATCH #update" do
    let(:employee) { create(:employee) }

    it "updates the employee with valid attributes" do
      patch :update, params: { employee_id: employee.id, employee: { name: "New Name" } }
      employee.reload
      expect(employee.name).to eq("New Name")
      expect(response).to have_http_status(:success)
    end

    it "returns unprocessable_entity status for invalid attributes" do
      patch :update, params: { employee_id: employee.id, employee: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "returns not_found for non-existent employee" do
      patch :update, params: { employee_id: 999, employee: { name: "New Name" } }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE #destroy" do
    let!(:employee) { create(:employee) }
    let!(:admin_user) { create(:employee, :admin) }

    it "destroys the employee" do
      # Set the current user to the admin user
      Current.current_user = admin_user

      expect {
        delete :destroy, params: { user_id: admin_user.id, employee_id: employee.id }
      }.to change(Employee, :count).by(-1)
    end

    it "returns success message on successful deletion" do
      # Set the current user to the admin user
      Current.current_user = admin_user

      delete :destroy, params: { user_id: admin_user.id, employee_id: employee.id }
      expect(response.body).to eq('Deletion done!')
    end
    
    it "returns not_found status for non-existent employee" do
      # Set the current user to the admin user
      Current.current_user = admin_user

      delete :destroy, params: { user_id: admin_user.id, employee_id: 999 }
      expect(response).to have_http_status(:not_found)
    end
  end
end
