require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params[:username] == '' || params[:password] == ''
     redirect '/failure'
   end
   user = User.new(username: params[:username], password: params[:password])
   if user.save
     redirect '/login'
   else
     redirect '/failure'
   end
  end

  get '/account' do
    @user = User.find(session[:user_id])
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    if params[:username] == '' || params[:password] == ''
     redirect '/failure'
   end
   user = User.new(username: params[:username], password: params[:password])
   if user && user.authenticate(params[:password])
     session[:user_id] = user.id
     redirect '/account'
   else
     redirect to '/failure'
   end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
