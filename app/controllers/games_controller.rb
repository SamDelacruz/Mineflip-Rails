# Controller for creating / showing game instances
class GamesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def create
    game = start_game
    render json: game, status: :created
  rescue => e
    render json: { message: e.message }, status: :internal_server_error
  end


  def show
    game = Game.find_by_id params[:id].to_i
    render json: game, status: :ok
  rescue => e
    render json: { message: e.message }, status: :not_found
  end

  private

  def start_game
    g = Game.start
    g.save
    g
  end
end
