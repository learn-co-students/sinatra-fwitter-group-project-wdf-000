require './config/environment'

class UserController < ApplicationController
  include Helpers
  configure do
    set :views, 'app/views/user'
  end
 
  get '/signup' do
    erb :new
  end

  get '/login' do
    if is_logged_in?(session)
      redirect to '/tweets'
    else
      erb :'session/new'
    end
  end

  post '/login' do
    user = User.all.detect {|user| user.username == params[:user][:username]} 
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect to '/tweets'
    else
      redirect to '/login'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

  post '/users' do
    if params[:user][:email].empty? || params[:user][:username].empty? || params[:user][:password].empty?
      redirect to '/signup'
    else
      user = User.create(params[:user])
      session[:user_id] = user.id
      redirect to '/tweets'
    end
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :show
  end
end
