require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
		set :session_secret, "tietoturva_salattu"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      @session = session
      erb :'/users/create_user'
    end
  end

  post '/signup' do
    user = User.find_by(:username => params[:username])
    user = User.find_by(:email => params[:email])

    # binding.pry
    user = User.create(params)
    if user.errors.messages.present?
      session[:signup_error] = user.errors.messages
      redirect '/signup'
    else
      session[:id] = user.id
      redirect '/tweets'
    end
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end


  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect "/tweets"
    else
      ##Should notify the user from false login info
      redirect "/login"
    end
  end


  get '/tweets' do
    if session[:id].present?
      @user = User.find(session[:id])
      @tweets = Tweet.all
      erb :'/tweets/tweets'
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @tweets = @user.tweets
    erb :'/tweets'
  end


  get '/tweets/new' do
    if logged_in?
      @session = session
      erb :'/tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    tweet = Tweet.create(params)
    user = User.find(session[:id])
    if tweet.errors.present?
      flash[:message] = tweet.errors.messages.values
      redirect '/tweets/new'
    else
      if current_user
        tweet.user = user
        tweet.save
        redirect '/tweets'
      end
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @session = session
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets/:id' do
    tweet = Tweet.find(params[:id])
    if logged_in? && current_user.id == tweet.user_id
      tweet = Tweet.update(params[:id], :content => params[:content])
      if tweet.errors.present?
         flash[:message] = tweet.errors.messages.values
         redirect "/tweets/#{params[:id]}/edit"
      else
         redirect "/tweets/#{params[:id]}"
      end
    else
      redirect '/login'
    end
  end

  post '/tweets/:id/delete' do
    tweet = Tweet.find(params[:id])
    if logged_in? && current_user.id == tweet.user_id
      Tweet.destroy(params[:id])
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

end
