class ApplicationController < ActionController::Base
  include Pundit

  Unauthenticated = Class.new(StandardError)

  rescue_from Pundit::NotAuthorizedError, with: :deny_access
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_locale

  helper_method :current_user, :signed_in?

  def authenticate_user!
    raise Unauthenticated unless signed_in?
  end

  def guest_only
    redirect_to root_path if signed_in?
  end

  def signed_in?
    current_user.present?
  end

  def current_user
    @current_user ||= session[:user_id] ? User.find(session[:user_id]) : nil
  end

  protected

  def deny_access
    render file: 'public/errors/403.html', layout: false, status: :forbidden
  end

  def record_not_found
    render file: 'public/errors/404.html', layout: false, status: :not_found
  end

  private

  def set_locale
    I18n.locale =
      extract_locale_from_accept_language_header ||
      I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    return unless accept_language

    accept_language.scan(/^[a-z]{2}/).first
  end
end
