class UserController < ApplicationController

  get '/signup' do
    if !session[:id]
      erb :'users/create_user'
    else
     current_user = User.find(session[:id])
      redirect to '/tweets'
    end

  end

  post '/signup' do 
    if !params[:username].empty? && !params[:email].empty? && !params[:password].empty?
      user = User.create(params)
      session[:id] = user.id
      redirect to '/tweets'
    else
      redirect to '/signup'
    end
  end

  get '/login' do 
    if !session[:id]
      erb :'users/login'
    else
      current_user
      redirect to '/tweets'
    end
  end

  post '/login' do 
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect to '/tweets'
    end
  end

  get '/logout' do
    if !!session[:id]
      session.clear
      redirect to '/login'
    else
      redirect to '/login'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'users/show'
  end

end