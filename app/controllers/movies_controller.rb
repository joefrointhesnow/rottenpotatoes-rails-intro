class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #@movies = Movie.all ============================================================================Part 1 9:47
    #@movies = Movie.find(:all, :order => (params[:sort_by] )) #Part 1
    @movies = Movie.order(params[:sort_by])
    #===============================================================================================Part 2 begin 9:56
    if params[:ratings]
      #=============================================================================================Part 2 11:52
      #@movies = Movie.where(:rating => params[:ratings].keys).find(params[:sort_by]) #=============Old code bottom line is updated!
      @movies = Movie.where(:rating => params[:ratings].keys).order(params[:sort_by])
    end
    @sort_column = params[:sort_by]
    #=============================================================================================Part 2 12:00
    @all_ratings = Movie.all_ratings
    @set_ratings = params[:ratings]
    if !@set_ratings
      @set_ratings = Hash.new
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
