module Api
  class BoardsController < ApplicationController 
    before_action :find_board, except: :index

    def index
      @boards = Board.with_items
      render json: @boards, status: 200
    end

    def show
      render json: @board, status: 200
    end

    def update
      @board.update_attributes board_params

      render json: @board, status: 200
    end

    private
    def board_params
      params.permit(:title)
    end

    def find_board
      @board = Board.find params[:id]
    end
  end
end
