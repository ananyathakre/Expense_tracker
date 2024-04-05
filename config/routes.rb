Rails.application.routes.draw do
  resources :employees do
    get "details", on: :member
  end
  resources :employees

  resources :expense_reports

  resources :expenses

  resources :comments

  resources :replies

end
