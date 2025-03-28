class MoviesController < ApplicationController
  def index
    movies = Movie.all
    render json: movies.as_json(only: [:id, :release_date, :title, :overview, :inventory, :available_inventory]), status: :ok
  end

  def show
    movie = Movie.find_by(id: params[:id])
    if movie
      render json: movie.as_json(only: [:id, :release_date, :title, :overview, :inventory, :available_inventory]), status: :ok
    else
      render json: {"errors" => {"id" => ["Movie with id #{params[:id]} not found."]}}
    end
  end

  def create

    movie = Movie.new(movie_params)

    if movie.save
      render json: movie.as_json(only: [:id]), status: :ok
      return
    else
      render json: {
        ok: false,
        errors: movie.errors.messages
      }, status: :bad_request
      return
    end
  end

  private
  def movie_params
    params.permit(:title, :overview, :release_date, :inventory).merge({ available_inventory: params[:inventory]} )
  end
end
