require './config/environment'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  configure do
    set :session_secret, "secret"
    enable :sessions
    set :public_folder, 'public'
    set :views, 'app/views'
  end
  use Rack::Flash

  get '/' do
    erb :'/application/index'
  end

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
      session[:user_id] = user.id
      flash[:message] = "Successfully Created Account"
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
      flash[:message] = "Successfully Logged In"
      redirect '/tweets'
    else
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      flash[:message] = "Successfully Logged Out"
      redirect '/login'
    else
      redirect '/'
    end
  end

end