class BoardsController < ApplicationController
  before_action :set_board, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: %i[index]
  
  def index
    # @boards = Board.all.includes(:user).order(created_at: :desc)
    @q = Board.ransack(params[:q])
    if params[:q].blank?
      @boards = Board.all.includes(:user).order(created_at: :desc).page(params[:page]).per(10)
    else
   #@boards = @q.result.includes(:user).distinct
    @boards = @q.result(distinct: true).page(params[:page]).per(10)
    end
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
    
    if @board.image.attached? && @board.image.filename.to_s != ""
      if @board.save
        redirect_to boards_path, success: I18n.t('board.post_aruaru', item: Board.model_name.human)
      else
        Rails.logger.debug(@board.errors.full_messages)
        flash.now['danger'] = I18n.t('board.failed_post_aruaru', item: Board.model_name.human)
        render :new, status: :unprocessable_entity
      end      
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

  # 新規追加 ランダムなboardを2つ選ぶ
  def random_boards
    boards = Board.order("RANDOM()").limit(2)
    boards_with_image_urls = boards.map do |board|
      image_url = board.image.attached? ? url_for(board.image.variant(resize: "512x512")) : nil
      board.attributes.merge({ image_url: image_url })
    end

    render json: boards_with_image_urls
  end

  # 新規追加　あるある選択ページ
  def which_major
    @boards = Board.all
  end


  private
  
  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:category, :body)
  end
end
