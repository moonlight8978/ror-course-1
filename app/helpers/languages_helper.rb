module LanguagesHelper
  def selectable_locales
    I18n.available_locales.reject { |locale| locale == I18n.locale }
  end
end
