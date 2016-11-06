class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      erb :"/tweets/index"
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :"/tweets/new"
    else
      redirect "/login"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :"/tweets/show"
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :"/tweets/edit"
    else
      redirect "/login"
    end
  end

  post '/tweets/new' do
    if !params[:content].empty?
      @tweet = Tweet.create(content: params[:content])
      @tweet.user_id = current_user.id
      @tweet.save
      redirect "/tweets/#{@tweet.id}"
    else
      redirect "/tweets/new"
    end
  end

  patch '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if @tweet.user_id = current_user.id
      @tweet.update(content: params[:content])
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
#why find_by vs find_by_id?
    @tweet = Tweet.find_by(params[:id])
    if @tweet.user_id = current_user.id
      @tweet.delete
      redirect "/tweets"
    end
  end
end
