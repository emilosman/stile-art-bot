class BoardsController < ApplicationController
  include ActionController::Live

  before_action :find_board, only: [:edit, :items, :destroy, :download]

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
    board = Board.new(title: board_params[:title])
    if board.save!
      redirect_to edit_board_path(board)
    end
  end

  def edit
    session[:board_ids] = [] unless session[:board_ids].present?
    session[:board_ids] << @board.id
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

  def download
    zipname = "#{@board.title} #{Time.now.strftime('%Y-%m-%d_%H-%M-%S')}.zip".gsub('"', '\"') # escape quotes
    disposition = ActionDispatch::Http::ContentDisposition.format(disposition: "attachment", filename: zipname)
  
    response.headers["Content-Disposition"] = disposition
    response.headers["Content-Type"] = "application/zip"
    response.headers.delete("Content-Length")
    response.headers["Cache-Control"] = "no-cache"
    response.headers["Last-Modified"] = Time.now.httpdate.to_s
    response.headers["X-Accel-Buffering"] = "no"

    writer = ZipTricks::BlockWrite.new do |chunk|
      response.stream.write(chunk)
    end
    ZipTricks::Streamer.open(writer) do |zip|
      @board.items.each do |item|
        zip.write_deflated_file(item.image.filename.to_s) do |file_writer|
          item.image.blob.download do |chunk|
            file_writer << chunk
          end
        end
      end
    end
  ensure
    response.stream.close
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
