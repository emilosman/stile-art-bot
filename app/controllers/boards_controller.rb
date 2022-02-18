class BoardsController < ApplicationController
  include ActionController::Live

  before_action :find_board

  def index;end

  def update
    if params[:orderedItems]
      params[:orderedItems].each do |item|
        Item.find(item[:item_id]).update(position: item[:position])
      end
    end
  end

  def items
    @items = @board.items.by_position

    render json: @items.to_json( {methods: [:image_url, :thumbnail_url]} ), status: 200
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
    @board = current_user.board
  end
end
