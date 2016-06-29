class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  # Enables secureheaders
  SecureHeaders::Configuration.default do |config|
    config.csp = {
      default_src: ["'self'"],
      script_src: [(ENV['SITE_URL'] || 'localhost'), "'self'"],
      connect_src: ["'self'"]
    }
  end

  # whitelists name attribute in devise
  def configure_permitted_parameters
    [:name].each do |sym|
      devise_parameter_sanitizer.for(:sign_up) << sym
      devise_parameter_sanitizer.for(:account_update) << sym
    end
  end
end
