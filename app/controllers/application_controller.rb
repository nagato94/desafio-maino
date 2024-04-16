class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  around_action :switch_locale
  
  def default_url_options(options={})
    options.merge({ locale: I18n.locale }) # Adiciona o locale nas requisições
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
