class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale

  protected

  def set_locale
    I18n.locale = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first || I18n.default_locale
  end
end
