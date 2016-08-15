class UserController < Sinatra::Base
  include Helpers::InstanceMethods

  get '/signup' do
    if logged_in?(session)
      erb :'/application/tweets'
    else
      erb :'/registration/signup'
    end
  end

  post '/signup' do
    user = User.create(params[:user])
    if user.save
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end
  end

  get '/login' do
    erb :'/application/login'
  end

  post '/login' do
    user = User.find_by(:username => params[:user][:username])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      redirect '/success'
    else
      redirect '/failure'
    end
  end

  get '/success' do
    if logged_in?(session)
      redirect '/tweets'
    else
      redirect '/failure'
    end
  end

  get '/failure' do
    erb :'/application/signup'
  end

  get 'logout' do
    session.clear
    redirect '/'
  end

end