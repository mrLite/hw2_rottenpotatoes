class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.select("distinct rating").map {|m| m.rating }
    @selected_ratings = params[:ratings] ? params[:ratings].keys : []
    if params[:sort]
      unless @selected_ratings.empty?
        @movies = Movie.where(:rating => @selected_ratings).order(params[:sort])
      else
        @movies = Movie.all(:order => params[:sort])
      end
      @hilite = params[:sort]
    else
      unless @selected_ratings.empty?
        @movies = Movie.where(:rating => @selected_ratings)
      else
        @movies = Movie.all
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
