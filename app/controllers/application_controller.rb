require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
  enable :sessions
  set :session_secret, "secret"
  set :public_folder, 'public'
  set :views, 'app/views'
  end

  get '/' do
    erb :'index'
  end


  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect "/tweets"
    end
  end


  post '/signup' do
    if params[:username] != "" && params[:email] != "" && params[:password] != ""
      @user = User.create(username: params[:username], password: params[:password], email: params[:email])
      @user.save
      session[:id] = @user.id
      redirect  "/tweets"
    else
      redirect '/signup'
    end
  end





  get '/login' do
    if !logged_in?
      erb :'users/login'
    else
      redirect "/tweets"
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


  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    elsif !logged_in?
    redirect '/'
    end
  end

  get '/tweets' do
    if logged_in?
      @user = User.find(session[:id])
      erb :'tweets/tweets'
    else
      redirect '/login'
    end
  end





  get '/tweets/new' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  post '/tweets/new' do
    if params[:content] != ""
      user = User.find(session[:id])
      tweet = Tweet.new(content: params[:content])
      tweet.user_id = user.id
      tweet.save
    end
  end




  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'tweets/show_tweet'
  end

  get '/tweets/:id' do
    if logged_in?
      tweet = Tweet.find(params[:id])
      @user = tweet.user
      redirect "/users/#{@user.slug}"
    else
      redirect "/login"
    end
  end




  get '/tweets/:id/edit' do

    if logged_in? && current_user == User.find(session[:id])
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit_tweet'
    else
      redirect "/login"
    end
  end



  post '/tweets/:id/edit' do
    if logged_in? && params[:content] != "" && params[:content] != nil
      @tweet = Tweet.find(params[:id])

      @tweet.update(content: params[:content])
      redirect "/tweets"
    else
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end



  post '/tweets/:id/delete' do

    @tweet = Tweet.find_by_id(params[:id])
     if logged_in? && current_user.id == @tweet.user_id
       @tweet.destroy
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
