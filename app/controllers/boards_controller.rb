class BoardsController < ApplicationController
  before_action :find_board, only: [:show, :edit]

  def index
    @boards = Board.all
  end

  def new
    @board = Board.new
  end

  def create
    board = Board.create(title: board_params[:title])

    redirect_to board
  end

  def show;end

  def edit;end

  private
  def find_board
    @board = Board.find params[:id]
  end

  def board_params
    params.require(:board).permit(:title)
  end
end
