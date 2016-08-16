class UserController < ApplicationController
  include Helpers::InstanceMethods

  get '/signup' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/registration/signup'
    end
  end

  post '/signup' do
    user = User.create(params)
    if user.save
      # binding.pry
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/signup'
    end
  end

  get '/login' do
    if logged_in?
      redirect '/tweets'
    else
      erb :'/application/login'
    end
  end

  post '/login' do
    user = User.find_by(:username => params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

end