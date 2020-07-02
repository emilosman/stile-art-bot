class ItemsController < ApplicationController
  before_action :find_item, only:[:update, :destroy]

  def create
    item = Item.new permit_params
    last_position = Board.find(params[:board_id]).items.maximum('position') || 0
    item.position = last_position + 1
    item.save

    render json: item.to_json({methods: :image_url}), status: 200
  end

  def update
    @item.update permit_params
  end

  def destroy
    @item.destroy
  end

  private
  def find_item
    @item = Item.find params[:id]
  end

  def permit_params
    params.permit(:board_id, :image, :position, :text, :id, :item)
  end
end
