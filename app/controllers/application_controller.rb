require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :'index'
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect '/tweets'
    end

    erb :'/users/create_user'
  end

  post '/signup' do
    if params[:user][:username].empty? || params[:user][:email].empty? || params[:user][:password].empty?
      redirect '/signup'
    end

    @user = User.create(params[:user])
    session[:user_id] = @user.id
    redirect :'/tweets'
  end

  get '/login' do
    if Helpers.current_user(session)
      redirect '/tweets'
    end

    erb :'/users/login'
  end

  post '/login' do
    user = User.find_by(params[:user])
    if user
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/users/:slug' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

    @user = User.find_by_slug(params[:slug])
    erb :'/users/show_user'
  end

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
    if params[:tweet][:content].empty?
      redirect '/tweets/new'
    end  

    user = Helpers.current_user(session)
    user.tweets << Tweet.create(params[:tweet])
    
    redirect "/users/#{user.slug}"
  end

  get '/tweets/:id' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end

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

    erb :'tweets/edit_tweet'
  end

  patch '/tweets/:id' do
    if params[:tweet][:content].empty?
      redirect "/tweets/#{params[:id]}/edit"
    end

    tweet = Tweet.find(params[:id])
    tweet.update(params[:tweet])
    redirect '/users/show_user'
  end

  delete '/tweets/:id/delete' do
    if !Helpers.is_logged_in?(session)
      redirect '/login'
    end
    
    @tweet = Tweet.find(params[:id])
    
    if !Helpers.current_user(session).tweets.include?(@tweet)
      redirect '/tweets'
    end 

    @tweet.destroy
    redirect '/tweets/tweets'
  end
end
