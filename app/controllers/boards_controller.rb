class BoardsController < ApplicationController
  before_action :find_board, only: [:edit, :items, :destroy]

  def index
    if Rails.env.production?
      @boards = session[:board_ids].present? ? Board.where(id: session[:board_ids]).with_items : []
    else
      @boards = Board.with_items
    end
  end

  def new
    @board = Board.new
  end

  def create
    session[:board_ids] = [] unless session[:board_ids].present?

    board = Board.create(title: board_params[:title])

    session[:board_ids] << board.id

    redirect_to edit_board_path(board)
  end

  def destroy
    @board.delete
    redirect_to boards_path
  end

  def update
    if params[:orderedItems]
      params[:orderedItems].each do |item|
        Item.find(item[:item_id]).update(position: item[:position])
      end
    end
  end

  def items
    if PAGINATE
      if params[:all]
        @items = @board.items
      else
        @items = @board.items.page(params[:page])
      end
    else
      @items = @board.items
    end

    render json: @items.to_json( {methods: :image_url} ), status: 200
  end

  def share
    @board = Board.find_by(share_id: params[:id])
    @items = @board.items.page(params[:page])
    render 'show'
  end

  private
  def find_board
    @board = Board.find params[:id]
  end

  def board_params
    params.require(:board).permit(:title, :position)
  end

  def authenticate_user
    if Rails.env.production?
      authenticate_or_request_with_http_basic do |name, password|
        name == ENV['USERNAME'] && password == ENV['PASSWORD']
      end
    end
  end
end
