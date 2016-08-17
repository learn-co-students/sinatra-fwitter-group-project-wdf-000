class TweetsController < ApplicationController
  
  # get '' do
  #   erb :'tweets/create_tweet'
  # end

  get '/tweets' do
    if session[:id]
      @user = User.find( session[:id] )
      erb :'tweets/tweets'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if session[:id]
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    if params[:content].empty?
      redirect '/tweets/new'
    elsif session[:id]
      user = User.find( session[:id] )
      user.tweets << Tweet.create(params)
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  get '/tweets/:id' do
    if session[:id]
      @tweet = Tweet.find( params[:id] )
      erb :'tweets/show_tweet'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if session[:id]
      @tweet = Tweet.find( params[:id] )
      erb :'tweets/edit_tweet'
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    if params[:content].empty?
      redirect "/tweets/#{params[:id]}/edit"
    elsif session[:id]
      tweet = Tweet.find( params[:id] )
      tweet.update( content: params[:content] )
      # user = User.find( session[:id] )
      # user.tweets << Tweet.create(params)
      redirect "/tweets/#{tweet.id}"
    else
      redirect "/login"
    end
  end 

  delete '/tweets/:id' do
    if session[:id]
      tweet = Tweet.find( params[:id] )
      user = User.find( session[:id] )
      if tweet.user_id == user.id
        tweet.delete
        redirect "/tweets"
      else
        redirect "/tweets/#{tweet.id}"
      end
    else
      redirect "/login"
    end
  end

end