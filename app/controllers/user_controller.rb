class UserController < ApplicationController

  get '/signup' do
    if session[:id]
      redirect '/tweets'
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    if !session[:id]
      if Helpers.valid_user?(session, params) == "valid"
        user = User.create(params)
        session[:id] = user.id
      else redirect '/signup'
      end
    end
    redirect '/tweets'
  end

  get '/login' do
    if !session[:id]
      erb :'users/login'
    else redirect '/tweets'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if User.find_by(username: params[:username]) && user.authenticate(params[:password])
      session[:id] = user.id
      redirect '/tweets'
    else redirect '/login'
    end
  end

  get '/logout' do
    if session[:id]
      session.clear
      redirect '/login'
    else redirect '/'
    end
  end

  get '/users/:username' do
    @user = User.find(username: params[:username])
    erb :'tweets/tweets'
  end

end
