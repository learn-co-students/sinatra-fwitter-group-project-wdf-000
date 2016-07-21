require './config/environment'
require 'bcrypt'

class ApplicationController < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  set :views, Proc.new { File.join(root, "../views/") }
  set :session_secret, "password_security"
  enable :sessions

  get '/' do
    if !session[:id]
      "Welcome to Fwitter"
    else
       erb :'tweet/tweets'
    end
  end

end
