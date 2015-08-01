class SessionsController < ApplicationController

  def new
  end

  def create
    if user = User.find_by(email: params[:email])
      login_as(user)
      redirect_to user_path
    else
      flash[:error] = "Invalid credentials"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end