Rails.application.routes.draw do

  resources :employees

  resources :expense_reports

  resources :expenses
 
  resources :comments

  resources :replies

end
