require './config/environment'
require 'pry'

class ApplicationController < Sinatra::Base
  configure do
  	enable :sessions
	set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do 
  	erb :'../index'
  end

  get '/signup' do 
  	if !logged_in?
  		erb :'/users/signup'

  	else
  		redirect "/tweets"
  	end
  end

  post '/signup' do 
  	if params[:username] != "" && params[:email] != "" && params[:password] != ""
  	@user = User.create(username: params[:username], email: params[:username], password: params[:password])
  	session[:user_id] = @user.id
  	@user.save
		redirect to "/tweets"
  	else
  		redirect to "/signup"
  	end
  end

  get '/login' do
  	if logged_in?
  		redirect to "/tweets"
  	end
  	erb :'/users/login'
  end

  post '/login' do 
  	@user = User.find_by(username: params[:username])
  	session[:user_id] = @user.id 
  	redirect to "/tweets"
  	# if @user && @user.authenticate(params[:password])
  	# 	session[:user_id] = @user.id
  	# 	redirect to "/tweets"
  	# else 
  	# 	redirect to "/logout"
  	# end
  end

  get '/logout' do 
  	if logged_in?
  		session.clear
  		redirect to "/login"
  	elsif !logged_in?
  		redirect to "/"
  	end
  end

get '/tweets' do 
	if logged_in?
		erb :'/tweets/tweets'
	elsif !logged_in?
		redirect to "/login"
	end
end

get '/tweets/new' do 
	if logged_in?
		erb :'/tweets/create_tweet'
		# binding.pry
	else
		redirect to "/login"
	end
end

post '/tweets' do 
	if params[:content] != ""
		# binding.pry
		@user = User.find(session[:user_id])
		@tweet = Tweet.new(content: params[:content])
		@tweet.user_id = @user.id
		@tweet.save
		redirect "/tweets/#{@tweet.id}"
	else
		redirect "/tweets/new"
	end
end

get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'tweets/show_tweet'
end

get '/tweets/:id' do 
	if logged_in?
		# binding.pry
		@tweet = Tweet.find_by_id(params[:id])
		@user = @tweet.user
		erb :"/tweets/show_tweet"
	else
		redirect "/login"
		
	end
end

 get '/tweets/:id/edit' do
 
    if logged_in? && (current_user == User.find_by_id(session[:user_id]))
    	
       @tweet = Tweet.find_by_id(params[:id])
       erb :'/tweets/edit_tweet'

   	else
         redirect "/login"
    end
 end

 post '/tweets/:id/edit' do
    if logged_in? && params[:content] != "" && params[:content] != nil
      @tweet = Tweet.find_by_id(params[:id])
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
      !!session[:user_id]
    end

    def current_user
     	User.find(session[:user_id])   
 	end
  	
 end

end