class TweetController < ApplicationController
  include Helpers::InstanceMethods

  get '/tweets' do
    if logged_in?
      @user = current_user(session)
      erb :'/users/tweet'
    else
      redirect '/login'
    end
  end

  get '/tweets/new' do
    if logged_in?
      @user = current_user(session)
      erb :'/tweets/new'
    else
      redirect '/login'
    end
  end

  post '/tweets' do
    tweet = Tweet.create(content: params[:content], user_id: session[:user_id])
    if tweet.save
      redirect '/tweets'
    else
      redirect '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show'
    else
      redirect '/login'
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/edit'
    else
      redirect '/login'
    end
  end

  patch '/tweets/:id/edit' do
    tweet = Tweet.find(params[:id])
    if params[:content].empty?
      redirect "/tweets/#{tweet.id}/edit"
    else
      tweet.update(content: params[:content])
    end
    redirect "/tweets/#{tweet.id}"
  end

  post '/tweets/:id/delete' do
    tweet = Tweet.find(params[:id])
    if tweet.user_id == session[:user_id]
      tweet.destroy
    end
    redirect '/tweets'
  end

end