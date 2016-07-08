class TweetsController < ApplicationController
  get '/tweets' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    @user = Helpers.current_user(session)
    erb :'/tweets/tweets'
  end

  get '/tweets/new' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    erb :'tweets/create_tweet'
  end

  post '/tweets' do
    if params[:content].empty?
      redirect '/tweets/new'
    end

    user = Helpers.current_user(session)
    user.tweets << Tweet.create(content: params[:content])

    redirect "/users/#{user.slug}"
  end

  get '/tweets/:id' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    @user = Helpers.current_user(session)
    @tweet = Tweet.find(params[:id])
    erb :'tweets/show_tweet'
  end

  get '/tweets/:id/edit' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    @tweet = Tweet.find(params[:id])

    if !Helpers.current_user(session).tweets.include?(@tweet)
      redirect '/tweets'
    end

    erb :'/tweets/edit_tweet'
  end

  patch '/tweets/:id' do
    if params[:content].empty?
      redirect "/tweets/#{params[:id]}/edit"
    end

    tweet = Tweet.find(params[:id])
    tweet.update(content: params[:content])
    redirect "/tweets"
  end

  delete '/tweets/:id/delete' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    tweet = Tweet.find(params[:id])

    if Helpers.current_user(session).tweets.include?(tweet)
      tweet.destroy
    end

    redirect '/tweets'
  end
end
