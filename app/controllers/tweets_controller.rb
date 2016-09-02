class TweetsController < ApplicationController

  get '/tweets' do
  	if logged_in?
  		@user = User.find(session[:user_id])
  		@tweets = Tweet.all
  		erb :'tweets/tweets'
  	else
  		redirect '/login'
  	end
  end

  get '/tweets/new' do
  	if logged_in?
  		@user = User.find(session[:user_id])
  		erb :'/tweets/create_tweet'
  	else
  		redirect '/login'
  	end
  end

  post '/tweets/new' do 
  	@user = User.find(session[:user_id])
  	if !params[:content].empty?
  		tweet = Tweet.create(params)
  		@user.tweets << tweet
  		redirect "/tweets/#{tweet.id}"
  	end
  end

  get '/tweets/:id' do
  	if logged_in?
  		@tweet = Tweet.find(params[:id])
  		erb :'tweets/show_tweet'
  	else
  		redirect '/login'
  	end
  end

  get '/tweets/:id/edit' do
  	if logged_in?
  		@tweet = Tweet.find(params[:id])
  		erb :'tweets/edit_tweet'
  	else
  		redirect '/login'
  	end
  end

  post '/tweets/:id/edit' do
  	user = User.find(session[:user_id])
  	tweet = Tweet.find(params[:id])
  	if tweet.user_id == user.id && !params[:content].empty?
  		tweet.update(content: params[:content])
  		redirect "/tweets/#{tweet.id}"
  	end
  end

  delete '/tweets/:id/delete' do
  	@tweet = Tweet.find(params[:id])
  	if @tweet.user_id == current_user.id
  		@tweet.destroy
  		redirect '/tweets'
  	end
  end

end