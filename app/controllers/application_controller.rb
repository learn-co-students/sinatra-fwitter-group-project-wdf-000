require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views/'
    enable :sessions
    set :session_secret, "fwitter_secret"
    use Rack::Flash
  end

  get '/' do 
    erb :index
  end
  
  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
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
      flash[:message] = "Please fill out all fields"
      redirect to "/signup"
    else
      user = User.create(username: params[:username], email: params[:email], password: params[:password]) 
      if user.save
        session[:id] = user.id
        redirect to "/tweets"
      else 
        redirect to "/signup"
      end 
    end
  end

  get '/login' do

    if session[:id] != nil
      redirect to '/tweets'
    else
      erb :'users/login'
    end
  end


  post '/login' do
    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:id] = user.id
      flash[:message] = "You are successfully logged in"
      redirect to '/tweets'
    else 
      redirect to '/signup'
    end
  end

  get '/tweets' do
    if !session[:id] 
      flash[:message] = "Please log in"
      redirect to '/login'
    else
      @user = User.find(session[:id])
      @tweets = Tweet.all
      erb :"tweets/tweets"
    end
  end

  get "/logout" do
    if session[:id] != nil
      session.clear
      redirect to '/login'
    else 
      redirect to "/tweets"
    end
  end

  get '/users/:slug' do
    user = User.create_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/tweets/new' do
    if !session[:id].nil?
     erb :'tweets/create_tweet'
    else
     redirect to '/login'
   end
  end

  post '/tweets' do
    if session[:id] != nil
      @user = User.find_by_id(session[:id])
      if !params[:content].empty?
        @tweet = Tweet.create(content: params[:content], user_id: @user.id)
        @user.tweets << @tweet
      else
        redirect to '/tweets/new'
      end
      @user.save
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to '/login'
    end
  end


  get '/tweets/:id' do
    if session[:id] != nil
      @user = User.find_by_id(session[:id])
      @tweet = Tweet.find_by_id(params[:id])

      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if session[:id] != nil
      @user = User.find_by_id(session[:id])
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect to '/login'
    end
  end


  post '/tweets/:id' do
    @user = User.find_by_id(session[:id])
    @tweet = Tweet.find(params[:id])
    if !params[:content].empty? && @tweet.user_id == @user.id
      @tweet.update(content: params[:content])
      @user.tweets << @tweet
      @user.save
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  post '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if !session[:id].nil? && @tweet.user_id == session[:id]
      Tweet.delete(params[:id]) 
      redirect to'/tweets'
    else
      redirect "/tweets/#{@tweet.id}"
    end
  end


end