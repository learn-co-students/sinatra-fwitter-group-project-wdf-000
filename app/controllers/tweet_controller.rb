class TweetController < ApplicationController

  get '/tweets' do
    if session[:id]
      @user = User.find(session[:id])
      erb :'index'
    else redirect '/login'
    end
  end

  get '/tweets/new' do
    if session[:id]
      erb :'tweets/create_tweet'
    else redirect '/login'
    end
  end

  post '/tweets/new' do
    if !params[:content].empty?
      @tweet = Tweet.create(params)
      @tweet.user_id = session[:id]
      @tweet.save
    end
  end

  get '/tweets/:id/edit' do
    redirect '/login' if !session[:id]
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id = session[:id]
      erb :'tweets/edit_tweet'
    else redirect '/tweets'
    end
  end

  delete '/tweets/:id' do
    redirect '/login' if !session[:id]
    @tweet = Tweet.find(params[:id])
    if @tweet.user_id == session[:id]
      Tweet.destroy(@tweet.id)
    else redirect '/tweets'
    end
  end

  get '/tweets/:id' do
    @tweet = Tweet.find(params[:id])
    if session[:id]
      erb :'tweets/show_tweet'
    else redirect '/login'
    end
  end

  patch '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    if !params[:tweet][:content].empty?
      @tweet.update(params[:tweet])
    end
  end












end
