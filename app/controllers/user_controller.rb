require 'rack-flash'
class UserController < ApplicationController

  get '/login' do
    if !session[:user_id]
      erb :'/users/login'
    else
      redirect to '/tweets'
    end
  end

  post '/login' do
        if params[:username].empty? || params[:password].empty?
          redirect to '/login'
        else
        @user = User.find_by(username: params[:username])
          if @user && @user.authenticate(params[:password])
          session[:user_id] = @user.id
          redirect to '/tweets'
        else
          redirect to '/application/signup'
          end
        end
  end

  get '/logout' do
    session.destroy
    redirect to '/login'
  end

  get "/users/:slug" do
    @user = User.find_by_slug(params[:slug])
    # @tweets = Tweet.find(user_id: @user.id)
    erb :'/tweets/tweets'
  end

end
