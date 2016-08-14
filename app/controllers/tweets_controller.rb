class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in? 
      @tweets = Tweet.all
      erb :'tweets/tweets'
    else
      redirect to '/login'
    end   
  end

  get '/tweets/new' do
    if logged_in? 
      erb :'tweets/create_tweet'
    else
      redirect to '/login'
    end   
  end

  get '/tweets/:id' do
    if !logged_in?
      redirect to '/login'
    else
      @tweet = Tweet.find_by(id: params[:id])
      erb :'tweets/show_tweet'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in? 
      @tweet = current_user.tweets.find_by(id: params[:id])
      if @tweet 
        erb :'tweets/edit_tweet'
      else
        redirect to '/tweets'
      end
    else
      redirect to '/login'
    end

  end

  post '/new_tweet' do
    if logged_in? && !params[:content].empty? 
      tweet = Tweet.create(params)
      tweet.user_id = current_user.id
      current_user.tweets << tweet
      redirect "/tweets/#{tweet.id}"
    elsif logged_in? && params[:content].empty?
      redirect to '/tweets/new'
    else
      redirect to '/login'
    end   
  end

  patch '/tweets/:id' do
    if params[:content].empty?
      redirect to "tweets/#{params[:id]}/edit"
    else
      @tweet = current_user.tweets.find_by(id: params[:id])
      @tweet.content = (params[:content])
      @tweet.save
      redirect to "tweets/#{@tweet.id}"
    end
  end

  post '/tweets/:id/delete' do
    if current_user.tweets.find_by(id: params[:id]) && session[:user_id] = current_user.id
       @tweet = Tweet.find_by(params[:id])
       @tweet.delete
       redirect to '/tweets'
     else 
       redirect to '/login'
    end
  end
end
