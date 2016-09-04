require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views/'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index 
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find_by(id: session[:id])
    end
  end

  get '/signup' do  
    if !session[:id] 
      erb :'users/create_user'
    else 
      redirect to '/tweets'
    end
  end


 post '/signup' do
    if params[:username] == "" || params[:email]== "" || params[:password] == ""
      redirect to "/signup"
    else
      user = User.create(username: params[:username], email: params[:email], password: params[:password]) 
      user.save
        session[:id] = user.id
        redirect to "/tweets"
    end
  end

  get '/login' do 
    if logged_in?
      redirect to "/tweets"
    else 
      erb :'/users/login'
    end
  end

  post "/login" do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id 
      redirect to '/tweets'
    else
      redirect to '/signup'
    end
  end

  get '/tweets' do 
    if !session[:id]
      redirect to '/login'
    else 
      @user = current_user
      @tweets = Tweet.all
      erb :'tweets/tweets'
    end
  end

  get '/logout' do 
    if logged_in?
     session.clear
     redirect to '/login'
    else 
     redirect to '/tweets'
   end
  end

  get '/users/:slug' do
    @user = current_user
    @tweets = @user.tweets
    erb :'/tweets/tweets'
  end

  get '/tweets/new' do 
    if !session[:id].nil?
      erb :'tweets/create_tweet'
    else 
      redirect to '/login'
    end
  end

  post '/tweets' do 
    if !session[:id].nil?
    @user = current_user
      if !params[:content].empty?
      @tweet = Tweet.create(content: params[:content], user_id: @user.id)
        @user.tweets << @tweet
      else 
        redirect to '/tweets/new'
      end
      @user.save
      redirect to :"/tweets/#{@tweet.id}"
    else 
      redirect to '/login'
    end
  end

  get '/tweets/:id' do 
    # @tweet = Tweet.find_by(params[:id])
    # erb :'/tweets/show_tweet'
    if !session[:id].nil? 
      # @user = current_user
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end


  get '/tweets/:id/edit' do 
     if !session[:id].nil?
        @user = current_user
        @tweet = @user.tweets.find_by_id(params[:id])
        erb :'/tweets/edit_tweet'
    else 
      redirect to '/login'
    end
  end

  post '/tweets/:id' do 
    if !session[:id].nil?
    @user = current_user
    @tweet = @user.tweets.find_by_id(params[:id])
      if !params[:content].empty?
        @tweet.update(content: params[:content])
        @user.tweets << @tweet
        @user.save
        redirect to :"/tweets/#{@tweet.id}"
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end
    else
        redirect to '/login'
    end
  end

  delete '/tweets/:id/delete' do 
    if !session[:id].nil?
      # user = current_user
      tweet = Tweet.all.find(params[:id])
       if tweet.user_id == current_user.id #session[:id]
        # binding.pry
          tweet.delete
          redirect to '/tweets' 
        else 
          redirect to '/tweets' 
        end
    else 
      redirect to '/login'
    end
  end




end





