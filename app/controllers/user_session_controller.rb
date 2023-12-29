class UserSessionController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def create
    @user = login(params[:email], params[:password])
    
    if @user
      flash[:success] = t('user_session.login_success')
      redirect_to boards_path
    else
      flash.now[:danger] = I18n.t('user_session.login_failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    flash[:success] = I18n.t('user_session.logout_success')
    redirect_to root_path, status: :see_other
  end
end
