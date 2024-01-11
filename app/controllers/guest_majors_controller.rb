class GuestMajorsController < ApplicationController
  skip_before_action :require_login, only: %i[create ]
  def create
    @guest_major = GuestMajor.new(guest_major_params)
    if @guest_major.save
      render json: { status: 'success' }
    else
      render json: { status: 'error' }
    end
  end

  private

  def guest_major_params
    params.require(:guest_major).permit(:board_id)
  end
end
