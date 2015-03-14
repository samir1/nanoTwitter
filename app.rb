require 'rubygems'
require 'sinatra'
require 'active_record'
require './models/user'
# require 'sinatra/active_record'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'db/sinatra_application.sqlite3.db'
)

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Login'
  end
end

before '/user/profile' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Must be logged into to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  if session[:identity]
    erb :timeline
  else
    erb :main
  end
end

get '/login' do 
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/secure/timeline'
  redirect to where_user_came_from 
end


get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end


get '/user/profile' do
  erb :timeline
end


#tweets
delete '/secure/:id' do
        tweet = Tweet.find_by_id(params[:id])
    if tweet
        tweet.destroy
        tweet.to_json
    else
        error 404, {:error => "tweet not found"}.to_json
    end
end

put '/user/register' do
    erb :register
end


