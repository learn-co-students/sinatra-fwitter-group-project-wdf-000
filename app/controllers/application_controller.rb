require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    # binding.pry
    if session[:id] != nil
      redirect to '/tweets'
    end
    erb :'/users/create_user'
  end

  post '/signup' do
    if params[:username].empty? || params[:email].empty?
      redirect to '/signup'
    elsif params[:password].empty?
      redirect to '/signup'
    else
      # binding.pry
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      session[:id] = @user.id
      # binding.pry
      redirect to '/tweets'
    end
  end

  get '/login' do
    # binding.pry
    if session[:id] != nil
      redirect to '/tweets'
    end
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    session[:id] = @user.id
    redirect to '/tweets'
    # binding.pry
  end

  get '/tweets' do
    if session[:id] == nil
      redirect to '/login'
    end
    @user = User.find_by(id: session[:id])
    # binding.pry
    erb :'/tweets/tweets'
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    # binding.pry
    erb :'/tweets/show_tweet'
  end

  get '/tweets/new' do
    # binding.pry
    if session[:id] != nil
      erb :'/tweets/create_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets/new' do

    if params[:content] != "" && session[:id] != nil
      @user = User.find_by(id: session[:id])
      @tweet = Tweet.create(params)
      @tweet.user = @user
      @user.tweets << @tweet
    else
      redirect to '/tweets/new'
    end
    # binding.pry
  end

  get "/tweets/:id" do
    if session[:id] != nil
      @tweet = Tweet.find_by(id: params[:id])
    # binding.pry
      erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if session[:id] != nil
      @tweet = Tweet.find_by(id: params[:id])
    # binding.pry
      erb :'/tweets/edit_tweet'
    else
      redirect to '/login'
    end
  end

  post '/tweets/:id/edit' do
    @tweet = Tweet.find_by(id: params[:id])
    # binding.pry
    @tweet.content = params[:content]
    @tweet.save
  end

  post '/tweets/:id/delete' do
    @tweet = Tweet.find_by(id: params[:id])
    if session[:id] == @tweet.user_id
      @tweet.destroy
    end
    # binding.pry
  end

end
