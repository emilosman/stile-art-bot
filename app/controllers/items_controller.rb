class ItemsController < ApplicationController
  def create
    item = Item.create permit_params

    render json: item.to_json({methods: :image_url}), status: 200
  end

  def update
    item = Item.find params[:id]
    item.update permit_params
  end

  private
  def permit_params
    params.permit(:board_id, :image, :position, :text, :id, :item)
  end
end
