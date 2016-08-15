class TweetController < ApplicationController

  get '/tweets' do
    if !session[:id]
      redirect to '/login'
    else
      erb :'/tweets/tweets'
    end
  end

  get '/tweets/new' do 
    if !session[:id]
      redirect to '/login'
    else
      @user = current_user
      erb :'/tweets/create_tweet'
    end
  end

  post '/tweets/new' do
    tweet = Tweet.new(params)
    if !tweet.content.blank?
      tweet.save
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    redirect_login
    @user = current_user
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/show_tweet'
  end

  delete '/:id/delete' do
    user = current_user
    @tweet = Tweet.find(params[:id])
    if user.id == @tweet.user_id
      @tweet.destroy
    else
      redirect to "/tweets/#{params[:id]}"
    end
  end

  get '/tweets/:id/edit' do
    redirect_login
    @tweet = Tweet.find(params[:id])
    erb :'/tweets/edit_tweet'
  end

  patch '/tweets/:id' do
    # binding.pry
    redirect_login
    # binding.pry
    @tweet = Tweet.find(params[:id])
    if !params[:tweet]["content"].blank?
      @tweet.update(params[:tweet])
      redirect to "/tweets/#{params[:id]}"
    else
      redirect to "/tweets/#{params[:id]}/edit"
    end
  end
end