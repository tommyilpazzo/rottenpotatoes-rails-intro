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
    # retrieves data from session
    if (params["sort_by"].nil? && not(session[:sort_by].nil?)) || 
      (params["ratings"].nil? && not(session[:ratings].nil?))
      params["sort_by"] = session[:sort_by] if params["sort_by"].nil?
      params["ratings"] = session[:ratings] if params["ratings"].nil?
      flash.keep
      redirect_to movies_path params 
    end
    # inits instance variables
    @css_class = {:title => '', :release_date => ''}
    @all_ratings = Movie.all_ratings
    @checked_ratings = params["ratings"].nil? ? @all_ratings : params["ratings"].keys
    # retrives movies applying rating filter
    @movies = Movie.where("rating IN (?)", @checked_ratings)
    # orders results and sets proper css class
    unless params["sort_by"].nil?
      @movies = @movies.order(params["sort_by"])
      @css_class[params["sort_by"].to_sym] = "hilite"  
    end
    # persist sort order and ratings filter
    session[:sort_by] = params["sort_by"] unless params["sort_by"].nil?
    session[:ratings] = params["ratings"] unless params["ratings"].nil? || params["ratings"].empty?
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
