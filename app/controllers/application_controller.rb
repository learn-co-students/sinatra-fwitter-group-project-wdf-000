require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  # HOMEPAGE actions
  get '/' do
    erb :index
  end

  get '/signup' do
    if is_logged_in?
      redirect to "/tweets"
    else
      erb :'/users/create_user'
    end
  end

  # Receive params from create_user view
  # Redirect to /tweets upon successful creation
  post '/signup' do
    params_has_empty_value = params.values.any? {|val| val.empty? || val.nil?}
    if params_has_empty_value
      redirect to "/signup"
    end

    @user = User.create(params)
    session[:user_id] = @user.id
    redirect to "/tweets"
  end

  get '/login' do
    if is_logged_in?
      redirect to "/tweets"
    else
      erb :'/users/login'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])

    if @user && @user.authenticate(params[:password])
      # flash[:notice] = "Welcome, #{@user.username}"
      session[:user_id] = @user.id
      redirect to '/tweets'
    else
      flash[:notice] = "Oops! Something ain't right... Try again."
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to "/login"
  end

  get '/tweets' do
    @tweets = Tweet.all

    if is_logged_in?
      erb :'/tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    # redirect to "/tweets/#{@user.slug}/show_tweet"
    erb :'/tweets/show_tweet'
  end

  get '/tweets/show_tweet' do
    if is_logged_in?
      # binding.pry
      redirect to "/users/#{current_user.slug}"
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if is_logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect to '/tweets/new'
    else
      tweet = Tweet.create(params)
      current_user.tweets << tweet
      redirect to '/tweets'
    end
  end

  ### Helpers ###
  helpers do
    def current_user
      User.find_by(id: session["user_id"])
    end

    def is_logged_in?
      !!session["user_id"]
    end
  end

end
