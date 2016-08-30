class TweetController < ApplicationController

    get "/tweets" do
      if session[:user_id]
      # if is_logged_in?
        @user = current_user
      erb :"/tweets/tweets"
    else
      redirect "/login"
    end
  end


  get "/tweets/new" do
    # if session[:id]
      # @user = current_user
    if is_logged_in?
      erb :"/tweets/create_tweet"
    else
      redirect "/login"
    end
  end

   post "/tweets/new" do
       if !params[:content].empty?
         user = User.find_by_id(session[:user_id])
         @tweet = Tweet.create(:content => params[:content], :user_id => user.id)
         redirect "/tweets/#{@tweet.id}"
       else
         redirect '/tweets/new'
       end
    end

    get "/tweets/:id" do
      if is_logged_in?
        @tweet = Tweet.find_by_id(params[:id])
        erb :"/tweets/show_tweet"
      else
        redirect "/login"
      end
    end


    delete "/tweets/:id/delete" do
      @tweet = Tweet.find_by_id(params[:id])
      if is_logged_in? && @tweet.user_id == current_user.id
        @tweet.delete
        redirect "/tweets"
      else
        redirect "/login"
      end
    end


    get '/tweets/:id/edit' do
      if is_logged_in?
        # && Tweet.find_by_id(params[:id]).user_id == current_user.id
        @tweet = Tweet.find_by_id(params[:id])
        erb :"/tweets/edit_tweet"
      else
        redirect "/login"
      end
    end

    patch "/tweets/:id/edit" do
      @tweet = Tweet.find_by_id(params[:id])
      if !params[:content].empty?
        @tweet.update(:content => params[:content])
        @tweet.save
        redirect "/tweets"
      else
        redirect "/tweets/#{@tweet.id}/edit"
      end

    end

end
