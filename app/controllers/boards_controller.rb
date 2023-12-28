class BoardsController < ApplicationController
  def index
    @boards = Board.all.includes(:user).order(created_at: :desc)
  end
end
