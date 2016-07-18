require './config/environment'

class TweetController < ApplicationController

  configure do
    set :views, 'app/views/tweet'
  end

  get '/tweets' do
    if session[:user_id]
      erb :index
    else
      redirect to '/login'
    end
  end

  post '/tweets' do
    if params[:tweet][:content].empty?
      redirect to '/tweets/new'
    else 
      tweet = Tweet.create(params[:tweet])
      redirect to "/tweets/#{tweet.id}" 
    end
  end

  get '/tweets/new' do
    if is_logged_in?(session)
      @user = User.find(session[:user_id]) 
      erb :new
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id' do
    if is_logged_in?(session)
      @tweet = Tweet.find(params[:id]) 
      erb :show
    else
      redirect to '/login'
    end
  end

  post '/tweets/:id' do
    if params[:tweet][:content].empty?
      redirect to "/tweets/#{params[:id]}/edit"
    else
      Tweet.find(params[:id]).update(params[:tweet])
    end
  end

  post '/tweets/:id/delete' do
    tweet = Tweet.find(params[:id])
    if !is_logged_in?(session) || tweet.user != current_user(session)
      redirect to '/login'
    else
      tweet.destroy
      redirect to '/tweets'
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find(params[:id])
    if is_logged_in?(session) && @tweet.user == current_user(session)
      erb :edit
    else
      redirect to "/tweets/#{params[:id]}"
    end
  end

  post '/tweets/:id/edit' do
    redirect to "/tweets/#{params[:id]}/edit"
  end
end
