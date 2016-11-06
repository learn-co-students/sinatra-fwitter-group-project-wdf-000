require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    # set :views, 'app/views'
    set :views, Proc.new { File.join(root, "../views/")}
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do
    erb :"home"
  end

  helpers do
    def logged_in?
      !!session[:id]
    end

    def current_user
      User.find(session[:id])
    end
  end
end
