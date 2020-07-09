class ItemsController < ApplicationController
  require 'open-uri'

  before_action :find_item, only:[:update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:create]

  def create
    if params[:image_url]
      image = open(params[:image_url])
    else params[:image]
      image = params[:image]
    end

    item = Item.new(
      board_id: params[:board_id],
      position: params[:position],
      text: params[:text]
    )

    item.image.attach(io: image, filename:'upload')

    last_position = Board.find(params[:board_id]).items.maximum('position') || 0
    item.position = last_position + 1
    item.save!

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
