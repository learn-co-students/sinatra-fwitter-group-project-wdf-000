require './config/environment'

class ApplicationController < Sinatra::Base
  include Helpers

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
    erb :'/users/create_user'
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
    erb :'/tweets/tweets'
  end

end
