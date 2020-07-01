class ItemsController < ApplicationController
  def create
    Item.create create_params
  end

  private
  def create_params
    params.permit(:board_id, :image)
  end
end
