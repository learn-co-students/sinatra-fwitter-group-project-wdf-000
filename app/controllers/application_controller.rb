require './config/environment'

class ApplicationController < Sinatra::Base
#add this line for edit or delete in views
#<input id="hidden" type="hidden" name="_method" value="patch/delete">
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    #enable sessions here
		enable :sessions
		#set :session_secret, "secret"
    set :session_secret, "password_security"
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end

  get '/' do
    erb :index
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/users/login'
    end
  end

  get '/logout' do
    if !logged_in?
      session.clear
    end
    redirect '/login'
  end

  get '/tweets' do
    @user = User.find_by(id:session[:id])
    if @user && logged_in?
      erb :'/tweets/tweets' 
    else
      redirect '/login'
    end
  end

  get '/signup' do
    if ( logged_in? )
      redirect '/tweets'
    else
      erb :'/users/create_user'
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/create_tweet'
    else
      redirect '/login'
    end
  end

  get '/users/:slug' do
    if ( logged_in? )
      redirect '/tweets'
    else
      erb :'/login'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @user = User.find_by(id:session[:id])
      @tweet = @user.tweets.detect{ |x| x.id == params[:id].to_i }
      if @tweet
        erb :'/tweets/show_tweet'
      else
        @tweet = Tweet.find_by(id:params[:id])
        erb :'/tweets/show'
      end
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    if !params[:content].empty?
      @tweet = Tweet.create(content:params[:content],user_id:session[:id])
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  post '/login' do
    @user = User.find_by(username:params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  post '/signup' do
    if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
      @user = User.create(username:params[:username],password:params[:password],email:params[:email])
      session[:id] = @user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by(id:params[:id])
      erb :'/tweets/edit_tweet'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id/edit' do
    if logged_in?
      @user = User.find_by(id:session[:id])
      @tweet = @user.tweets.detect{ |x| x.id == params[:id].to_i }
      if @tweet
        @tweet.update(content:params[:content]) unless params[:content].empty?
        erb :'/tweets/show_tweet'
      end
    else
      redirect '/login'
    end
  end

  delete '/tweets/:id/delete' do
    if logged_in?
      @user = User.find_by(id:session[:id])
      @tweet = @user.tweets.detect{ |x| x.id == params[:id].to_i }
      if @tweet
        Tweet.delete(params[:id])
        redirect '/tweets'
      end
    else
      redirect '/login'
    end
  end

end
