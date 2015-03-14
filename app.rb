require 'rubygems'
require 'sinatra'
require 'active_record'
require './models/user'
require './models/tweet'
# require 'sinatra/active_record'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'db/production.sqlite3'
)

configure do
  enable :sessions
end

helpers do
  def username
    session[:username] ? session[:username] : 'Login'
  end
end

before '/user/profile' do
  if !session[:username] then
    session[:previous_url] = request.path
    @error = 'Must be logged into to visit ' + request.path
    halt erb(:login_form)
  end
end

before '/tweet' do
  if !session[:username] and session[:username] != @current_user.username then
    session[:previous_url] = request.path
    @error = 'Must be logged into to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  if session[:username]
    erb :timeline
  else
    erb :main
  end
end

get '/login' do 
  erb :login_form
end

post '/login/attempt' do
  @current_user = User.find_by(username: params[:username], password: params[:password])
  if !@current_user
    redirect to '/login'
  else
    session[:username] = @current_user.username
    session[:name] = @current_user.name
    session[:email] = @current_user.email
    session[:id] = @current_user.id
  end
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/logout' do
  session.clear
  erb "<div class='alert alert-message'>Logged out</div>"
end


get '/user/profile' do
  erb :profile
end


#tweets
delete '/delete/:id' do
        tweet = Tweet.find_by_id(params[:id])
    if tweet
        tweet.destroy
        tweet.to_json
    else
        error 404, {:error => "tweet not found"}.to_json
    end
end

get '/user/register' do
  erb :register
end

post '/user/register/attempt' do
  # u = User.new(name: "Samir Undavia", username: "samir1", email: "samir1@brandeis.edu", password: "samir123")
  @current_user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
  if @current_user.save
    session[:username] = params[:username]
    session[:name] = params[:name]
    session[:email] = params[:email]
    session[:id] = params[:id]
    redirect to "/user/profile"
  else
    erb :register
  end
end

post '/tweet' do
  puts '****************1'
  tweet = Tweet.new(text: params[:tweet], owner: session[:id])
  puts '****************2'
  tweet.save!
  redirect to '/'
end


