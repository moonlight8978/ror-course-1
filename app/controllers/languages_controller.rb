class LanguagesController < ApplicationController
  def index
    session[:locale] = params[:locale]
    redirect_back fallback_location: root_path
  end
end
