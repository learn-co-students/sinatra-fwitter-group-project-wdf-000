require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views/'
    enable :sessions
    set :session_secret, "!@$%^&QWERasdf"
    use Rack::Flash
  end

  get '/' do 
  	erb :index
  end

  get '/signup' do

  	if !session[:id].nil?
      flash[:message] = "You have logged in."
      redirect '/tweets'
	  else
      erb :'users/create_user'
	  end
  end

  post '/signup' do
  	
  	if params[:username].empty? ||
  		params[:email].empty? ||
  		params[:password].empty?
  		flash[:message] = "You have to fill all fields."
  		redirect '/signup'
  	else

  		user = User.new(username: params[:username],
  										email: params[:email],
  										password: params[:password])
  		if user.save
        session[:id] = user.id
  			redirect '/tweets'
  		else
  			flash[:message] = "Failed to sign up."
  			redirect '/signup'
  		end
  		
  	end
  end

  get '/login' do 
    if !session[:id].nil?
      flash[:message] = "You have logged in."
      redirect '/tweets'
    else
      erb :'users/login'
    end
  	
  end

  post '/login' do 
  	if params[:username].empty? ||
  		params[:password].empty?
  		flash[:message] = "You have to fill all fields."
  	else
  		user = User.find_by(username: params[:username])

  		if user && user.authenticate(params[:password])
  			session[:id] = user.id
	  		# redirect "/users/#{user.slug}"

        redirect '/tweets'
	  	else
	  		flash[:message] = "Failed to log in."
  			redirect '/login'
	  	end
  	end
  end


  get "/tweets" do 
    if !session[:id].nil?
      @user = User.find(session[:id])
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      flash[:message] = "Please log in first."
      redirect '/login'
    end
  end

  get '/logout' do 
    if session[:id].nil?
      redirect '/'
    else
      session.clear
      redirect '/login'
    end
  end

  get "/users/:slug" do 
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end





  get '/tweets/new' do 
    if !session[:id].nil?

      erb :'tweets/create_tweet'
    else
      flash[:message] = "Please log in first."
      redirect '/login'
    end
  end

  post '/tweets' do 
    if !session[:id].nil?
      user = User.find(session[:id])
      if !params[:content].empty?
        tweet = Tweet.create(content: params[:content])
        user.tweets << tweet
      else
        flash[:message] = "Content cannot be empty."
        redirect '/tweets/new'
      end
    else
      flash[:message] = "Please log in first."
      redirect '/login'
    end
  end

  get "/tweets/:id" do 
    if !session[:id].nil?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/show_tweet'
    else
      flash[:message] = "Please log in first."
      redirect 'login'
    end
  end

  get '/tweets/:id/edit' do 
    if !session[:id].nil?
      @tweet = Tweet.find(params[:id])
      erb :'tweets/edit_tweet'
    else
      flash[:message] = "Please log in first."
      redirect 'login'
    end
  end

  post '/tweets/:id' do 
    @tweet = Tweet.find(params[:id])
    if !params[:content].empty? || params[:content] == @tweet.content
      if @tweet.user_id == session[:id]
        @tweet.update(content: params[:content])
      else
        flash[:message] = "You cannot change this tweet."
        redirect "/tweets/#{@tweet.id}/edit"
      end
    else
      flash[:message] = "Content cannot be empty."
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  post '/tweets/:id/delete' do 

    @tweet = Tweet.find(params[:id])
    if !session[:id].nil?
      Tweet.delete(params[:id]) if @tweet.user_id == session[:id]
      redirect 'tweets'
    else
      redirect "/tweets/#{@tweet.id}"
    end

  end
  

end




