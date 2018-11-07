class RegistrationsController < ApplicationController
  layout 'auth'

  before_action :guest_only

  def new
    @user = User.new
  end

  def create
    @user = User.create(registration_params)
    if @user.errors.empty?
      session[:user_id] = @user.id
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def registration_params
    params.require(:user)
      .permit(:email, :username, :password, :password_confirmation)
  end
end
