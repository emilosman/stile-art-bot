class BoardsController < ApplicationController
  def index;end

  def new
    @board = Board.new
  end

  def create
    board = Board.create(title: params[:title])

    redirect_to board
  end

  def show
    @board = Board.find params[:id]
  end
end
