require './config/environment'

class ApplicationController < Sinatra::Base
  include Helpers
  configure do
    set :public_folder, 'public'
    enable :sessions
    set :session_secret, "qwertyuiop"
    set :views, 'app/views'
  end

  get '/' do
    erb :'../home'
  end

end
