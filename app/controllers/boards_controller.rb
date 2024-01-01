class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: %i[index]
  
  def index
    @boards = Board.all.includes(:user).order(created_at: :desc)
    @board = Board.new
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
    @board = Board.new
  end

  def edit; end

  def create
    @board = Board.new(board_params)
    @board.user = current_user
    begin
      prompt = "purpose：あるある事例を紹介したい, situation：#{@board.category}, detail：#{@board.body}, constraints：without subtitles"
      image_key = ChatgptService.download_image(prompt)
      @board.image.attach(ActiveStorage::Blob.find_by(key: image_key)) if image_key
    rescue Net::ReadTimeout
      flash.now['danger'] = I18n.t('ja.board.failed_post_aruaru', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
    # begin
      # @board.body = ChatgptService.call("次の入力文を関西弁にしてください 入力文：#{@board.body}")
    # rescue Net::ReadTimeout
    # end
    if @board.save
      redirect_to boards_path, success: I18n.t('board.post_aruaru', item: Board.model_name.human)
    else
      Rails.logger.debug(@board.errors.full_messages)
      flash.now['danger'] = I18n.t('board.failed_post_aruaru', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy
    @board.destroy!
    redirect_to boards_path, success: t('board.delete_aruaru', item: Board.model_name.human)
  end

  private
  
  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:category, :body)
  end
end
