class MinorsController < ApplicationController
  before_action :find_board
  def create
     @board.minors.where(user: current_user).first_or_create
    redirect_to boards_path
  end

  def destroy
    @board.minors.where(user: current_user).destroy_all
    redirect_to boards_path
  end
  private

  def find_board
    @board = Board.find(params[:board_id])
  end
end