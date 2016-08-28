require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'

    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if !is_logged_in?
      erb :'users/create_user'
    else
      redirect '/tweets', params
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/tweets' do
    if is_logged_in?
      @user = current_user
      erb :'tweets/tweets'
    else
      redirect '/login'
    end

  end

  get '/login' do
    if !is_logged_in?
      erb :'users/login'
    else
      redirect '/tweets'
    end
  end

  post '/login' do
    #assign user_id to the session hash
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if is_logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'tweets/tweets'
  end

  get '/tweets/new' do
    if is_logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if !params[:content].empty?
      current_user.tweets << Tweet.create(params)
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if is_logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if is_logged_in? && Tweet.find_by_id(params[:id]).user_id == current_user.id
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])

    if !params[:content].empty?
      @tweet.update(content: params[:content])
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end

  end

  delete '/tweets/:id/delete' do
    if is_logged_in? && Tweet.find_by_id(params[:id]).user_id == current_user.id
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.delete
    else
      redirect '/login'
    end
  end

  helpers do
    def is_logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end
end