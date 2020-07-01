class ItemsController < ApplicationController
  def create
    item = Item.create(board_id: params[:board_id])

    item.image.attach params[:image]

    if item.image.attached?
      item.save
    else
      item.delete
    end
  end

  private
  def create_params
    params.permit(:board_id, :image)
  end
end
