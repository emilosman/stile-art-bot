class BoardsController < ApplicationController
  before_action :find_board, only: [:show, :edit, :items]

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def create
    board = Board.create(title: board_params[:title])

    redirect_to edit_board_path(board)
  end

  def show;end

  def edit;end

  def update
    if params[:orderedItems]
      params[:orderedItems].each do |item|
        Item.find(item[:item_id]).update(position: item[:position])
      end
    end
  end

  def items
    render json: @board.to_json( include: {items: {methods: :image_url}} ), status: 200
  end

  private
  def find_board
    @board = Board.find params[:id]
  end

  def board_params
    params.require(:board).permit(:title, :position)
  end
end
