class UserSessionController < ApplicationController
  skip_before_action :require_login, only: %i[new create]
  def create
    @user = login(params[:email], params[:password])
    
    if @user
      redirect_to boards_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other
  end
end
