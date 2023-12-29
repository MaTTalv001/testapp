class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      session[:user_id] = user.id
      flash[:success] = I18n.t('user.create_success')
      redirect_to root_url
    else
      flash.now[:danger] = I18n.t('user.create_failure')
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'ログアウトしました。'
  end
end
