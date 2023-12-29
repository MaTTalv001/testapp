class BoardsController < ApplicationController
  def index
    @boards = Board.all.includes(:user).order(created_at: :desc)
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
      prompt = "#{@board.category}, #{@board.body}"
      image_filename = ChatgptService.download_image(prompt)
      @board.image_filename = image_filename if image_filename
    rescue Net::ReadTimeout
      flash.now['danger'] = I18n.t('defaults.message.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
    # begin
      # @board.body = ChatgptService.call("次の入力文を関西弁にしてください 入力文：#{@board.body}")
    # rescue Net::ReadTimeout
    # end
    if @board.save
      redirect_to boards_path, success: I18n.t('defaults.message.created', item: Board.model_name.human)
    else
      Rails.logger.debug(@board.errors.full_messages)
      flash.now['danger'] = I18n.t('defaults.message.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update; end

  def destroy; end

  private

  def board_params
    params.require(:board).permit(:category, :body)
  end
end
