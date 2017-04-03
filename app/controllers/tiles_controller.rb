class TilesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def update
    game_id = Integer(params[:game_id]) rescue nil
    tile_x  = Integer(params[:tile_x]) rescue nil
    tile_y  = Integer(params[:tile_y]) rescue nil

    unless tile_x && tile_y
      render nothing: true, status: :bad_request
      return
    end

    begin
      game = Game.find_by_id game_id
    rescue => e
      render json: { message: e.message }, status: :not_found
      return
    end

    game.reveal_tile(tile_x, tile_y)
    game.save
    render json: game, status: :ok
  #rescue => e
    #render json: { message: e.message }, status: :unprocessable_entity
  end
end
