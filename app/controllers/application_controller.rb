class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions
  include DeviseTokenAuth::Concerns::SetUserByToken
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_action :authenticate_user!, except: [:omniauth_failure, :omniauth_success, :redirect_callbacks, :omniauth_failure, :facebook_login]
  before_action :set_default_response_format
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  check_authorization :unless => :devise_controller?

  # Set the current ability to the user according to the user role.
  def current_ability
    if user_signed_in?
      @current_ability ||= Ability.new(current_user)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    render :unauthorized, format: :json, status: 401
  end

  # Return error when record not found in the database.
  def record_not_found
    render json: {error: I18n.t('errors.not_found')}.to_json, status: 404
  end


  #######
  private
  #######

  # Set the default format JSON for the response.
  def set_default_response_format
    request.format = :json
  end

end
