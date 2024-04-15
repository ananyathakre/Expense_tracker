Rails.application.routes.draw do
  # config/routes.rb
resources :employees, only: [:update], param: :employee_id
delete 'employees/:user_id/:employee_id', to: 'employees#destroy'
resources :employees, only: [:show, :create],param: :user_id

  resources :expense_reports

  resources :expenses

  resources :comments

  resources :replies

end
