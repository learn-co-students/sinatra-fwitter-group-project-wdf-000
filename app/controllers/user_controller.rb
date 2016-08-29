class UserController < ApplicationController

  get "/" do
    erb :"/users/home"
  end

  get '/login' do
    if !is_logged_in?
      #if noone is logged in -> users/login page
      #else, if user is logged in, redirect to tweets/dont let them see login page
      erb :"users/login"
    else
      redirect "/tweets"
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  get "/signup" do
    if is_logged_in?
      redirect "/tweets"
    else
      erb :"/users/create_user"
    end
  end

  post "/signup" do
     if !params[:username].empty? && !params[:password].empty? && !params[:email].empty?
       @user = User.create(params)
       session[:user_id] = @user.id
       redirect '/tweets'
    else
        redirect '/signup'
      end
    end

  get "/logout" do
    if is_logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/"
    end
  end

  get "/users/:slug" do
      @user = User.find_by_slug(params[:slug])
      erb :"/users/show"
  end



end
