require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  # use Rack::Flash
  # use Rack::MethodOverride
  # register Sinatra::ActiveRecordExtension
  # register Sinatra::ActiveRecordExtension
  # register Sinatra::Twitter::Bootstrap::Assets
  #
  # enable :sessions
  # set :session_secret, "my_application_secret"
  # set :views, Proc.new { File.join(root, "../views/") }

    register Sinatra::ActiveRecordExtension
    register Sinatra::Twitter::Bootstrap::Assets
    enable :sessions
    use Rack::Flash
    use Rack::MethodOverride
    set :session_secret, "my_application_secret"

    configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    end

    get '/' do
      erb :'/application/index'
    end

    get '/signup' do
        if !session[:user_id]
        erb :'/users/signup'
      else
        redirect to '/tweets'
      end
    end

    post '/signup' do
        if params[:username].empty? || params[:email].empty? || params[:password].empty?
          flash[:message] = "Do not leave anything blank."
          redirect to '/signup'
        else
          @user = User.new(username: params[:username], email: params[:email], password: params[:password])
          @user.save
          session[:user_id] = @user.id
          redirect to '/tweets'
        end

  end

end
