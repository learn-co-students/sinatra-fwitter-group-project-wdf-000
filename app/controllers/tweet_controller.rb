class TweetController < ApplicationController

  get '/tweets' do
    if session[:user_id]
      # @tweets = Tweets.all
    erb :'tweets/tweets'
    else
      redirect to '/login'
    end
  end

  get '/tweets/new' do
    if session[:user_id]
    erb :'tweets/new'
  else
    redirect to '/login'
    end
  end

  post '/tweets/new' do
    if !params[:content].empty?
    @tweet = Tweet.new(:content => params[:content])
    @tweet.save
    @user= User.find(session[:user_id])
    @user.tweets << @tweet
    @user.save
    else
      redirect to '/tweets/new'
    end

    redirect to "/users/#{@user.slug}"
  end

  get '/tweets/:id' do
    if session[:user_id]
    @tweet = Tweet.find(params[:id])
    @tweet.save
    erb :'/tweets/tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if session[:user_id]
    @tweet = Tweet.find(params[:id])
    @tweet.save
    erb :'/tweets/edit'
    else
      redirect to '/login'
    end
  end

  patch '/tweets/:id/edit' do
    if !params[:content].empty?
    @tweet = Tweet.find(params[:id])
    @tweet.update(:content => params[:content])
    @tweet.save
    redirect to "/tweets/#{@tweet.id}"
    else
      redirect to "tweets/#{@tweet.id}/edit"
    end
  end
   delete '/tweets/:id/delete' do
  # post '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    @tweet.save
    if @tweet.user_id == session[:user_id]
    @tweet.delete
    redirect to '/tweets'
    else
      redirect to '/tweets'
    end
  end

end
