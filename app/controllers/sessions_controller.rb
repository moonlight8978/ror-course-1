class SessionsController < ApplicationController
  before_action :authenticate_user!, only: :destroy
  before_action :guest_only, except: :destroy

  def new
    @user = User.new
  end

  def create
    @user = User.authenticate(login_params)
    if @user.errors.any?
      render :new
    else
      session[:user_id] = @user.id
      redirect_to root_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to sign_in_path
  end

  private

  def login_params
    params.require(:user).permit(:email, :password)
  end
end
