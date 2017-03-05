
class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email:params[:session][:email].downcase)
    if user&& user.authenticate(params[:session][:password])
    #其实就是if 前面， true则(1:2)中选1，false则选2
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_back_or user
    else
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end

  end


  def destroy
    #logged_in 是通过current_user的值来判断的
    log_out if logged_in?
    redirect_to root_url
  end


end
