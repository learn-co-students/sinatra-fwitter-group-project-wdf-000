require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  include Helpers
  use Rack::Flash

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  # HOMEPAGE actions
  get '/' do
    erb :index
  end

  get '/signup' do
    if is_logged_in?(session)
      redirect to "/tweets"
    else
      erb :'/users/create_user'
    end
  end

  get '/login' do
    erb :'/users/login'
  end

  # Receive params from create_user view
  # Redirect to /tweets upon successful creation
  post '/signup' do
    params_has_empty_value = params.values.any? {|val| val.empty? || val.nil?}
    if params_has_empty_value
      redirect to "/signup"
    end

    @user = User.create(params)
    session[:user_id] = @user.id
    redirect to "/tweets"
  end

  # Display all created tweets
  get '/tweets' do
    @tweets = Tweet.all
    erb :'/tweets/tweets'
  end

  get '/login' do
    erb :'/users/login'
  end

  post '/login' do
    @current_user = User.find_by(username: params[:username])

    if @current_user && @current_user.authenticate(params[:password])
      session[:user_id] = @current_user.id
      flash[:notice] = "Welcome, #{@current_user.username}"
      redirect to '/tweets'
    else
      flash[:notice] = "Oops! Something ain't right... Try again."
      redirect to '/login'
    end
  end

end
