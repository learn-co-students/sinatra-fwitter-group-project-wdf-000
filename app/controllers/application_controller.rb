require './config/environment'
# require 'rack-flash'

class ApplicationController < Sinatra::Base
  # use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  configure do
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do 
    erb :index
  end

  get '/signup' do 
    if session[:id]
      @user = User.find_by_id(session[:id])
      redirect '/tweets'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do 
    if params.values.any? {|value| value.empty?}
      # flash[:message] = "Please fill out all fields."
      redirect '/signup'
    else
      @user = User.create(params)
      session[:id] = @user.id
      redirect '/tweets'
    end
  end

  get '/login' do 
    if session[:id]
      @user = User.find_by_id(session[:id])
      redirect '/tweets'
    else
      erb :'users/login'
    end
  end

  post '/login' do 
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/tweets' do 
    if session[:id]
      @user = User.find_by_id(session[:id])
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else  
      redirect '/login'
    end
  end

  get '/logout' do 
    session.clear
    redirect '/login'
  end

  get '/users/:slug' do 
    @user = User.find_by_slug(params[:slug])
    @user_tweets = Tweet.select {|tweet| tweet.user_id == @user.id}
    erb :'tweets/all_by_user'
  end

  get '/tweets/new' do 
    if session[:id]
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do 
    if !params[:content].empty? 
      @user = User.find_by_id(session[:id])
      @new = Tweet.create(params)
      @new.user_id = @user.id
      @new.save
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do 
    if session[:id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do 
    if session[:id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if !params[:content].empty?
      @tweet.update(content: params[:content])
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  post '/tweets/:id/delete' do 
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user_id == session[:id]
      Tweet.destroy(@tweet.id)
    else
      redirect '/tweets'
    end
  end

end