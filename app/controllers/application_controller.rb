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

  get '/users/:slug' do 
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

  get '/signup' do
    if !session[:user_id]
      erb :'users/create_user', locals: {message: "Sign up before sign in"}
    else
      redirect to '/tweets'
    end
  end

  post '/signup' do
    if params[:username] == "" || params[:email] == "" || params[:password] == "" 
      redirect to '/signup'
    else
      @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
      @user.save
      session[:user_id] = @user.id
      redirect to '/tweets'
    end
  end

  get '/login' do 
      if !session[:user_id]
        erb :'users/login'
      else
        redirect '/tweets'
      end
  end

  	post '/login' do
  		user = User.find_by(username: params[:username])
  		if user && user.authenticate(params[:password])
  			session[:user_id] = user.id 
  			redirect '/tweets'
  		else
  			redirect '/signup'
  	end
  end

  get '/logout' do 
    if session[:user_id] != nil
      session.destroy
      redirect to '/login'
    else
      redirect to '/'
    end
  end

  get '/tweets' do 
    if session[:user_id]
      @tweets = Tweet.all 
      erb :'/tweets/tweets'
    else 
      redirect to '/login'
  end
end

  get '/tweets/new' do 
    if session[:user_id]
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
  end
end

  post '/tweets' do 
    if params[:content] == ""
      redirect to '/tweets/new'
    else
      user = User.find_by_id(session[:user_id])
      @tweet = Tweet.create(:content => params[:content], :user_id => user.id)
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  get '/tweets/:id' do 
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do 
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == session[:user_id]
        erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id' do 
    if params[:content] == ""
      redirect to "/tweets/#{params[:id]}/edit"
    else
      @tweet = Tweet.find_by_id(params[:id])
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    end
  end

  delete '/tweets/:id/delete' do 
    @tweet = Tweet.find_by_id(params[:id])
    if session[:user_id]
      @tweet = Tweet.find_by_id(params[:id])
      if @tweet.user_id == session[:user_id]
        @tweet.delete
        redirect to '/tweets'
      else
        redirect to '/tweets'
      end
    else
        redirect to '/login'
      end
    end

  	helpers do
  		def logged_in?
  			!!session[:user_id] 
  		end

  		def current_user
  			User.find(session[:user_id])
  		end
  	end

  end