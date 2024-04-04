class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection
  protect_from_forgery with: :exception
  include Pundit
  def current_user
    Thread.current[:user]
  end
end
