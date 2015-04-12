require 'rubygems'
require 'sinatra'
require 'json'
require 'sinatra/jsonp'
require 'active_record'
require './models/user'
require './models/tweet'
require './models/follow'
require 'bundler/setup'
require 'faker'


# require 'sinatra/active_record'

configure do
    enable :sessions
    env = ENV["SINATRA_ENV"] || "development"
    databases = YAML.load(ERB.new(File.read("config/database.yml")).result)
    ActiveRecord::Base.establish_connection(databases[env])
    # load 'seeds.rb'
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
    if !session[:username] then
        session[:previous_url] = request.path
        @error = 'Must be logged into to visit ' + request.path
        error 400
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

get '/loaderio-2aee583d8cfdd329307e880970966129/' do
  "loaderio-2aee583d8cfdd329307e880970966129"
end

post '/login/attempt' do
    @current_user = User.find_by(username: params[:username], password: params[:password])
    if !@current_user
        error 400, jsonp({:error => "invalid login credentials"})
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

delete '/delete' do
    tweet = Tweet.find_by_id(params[:id])
    if tweet
        tweet.destroy
        tweet.to_json
    else
        error 400, {:error => "tweet not found"}
    end
end

get '/user/register' do
    erb :register
end

post '/user/register/attempt' do
   # @json = JSON.parse(request.body.read)
   # @json = @json.split
  #  @current_user = User.new(name: @json["name"], username: @json[, email: @json["email"], password: @json["password"])'
    @current_user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
    if @current_user.save
        session[:username] = params[:username]
        session[:name] = params[:name]
        session[:email] = params[:email]
        session[:id] = User.where(username: params[:username]).take.id
        redirect to "/user/profile"
    else
        erb :register
        error 400, "unable to register"
    end
end

#tweet
post '/tweet' do
    tweet = Tweet.new(text: params[:tweet], owner: session[:id])
    tweet.save!
    redirect to '/'
end

get '/user/:username' do
    erb :user
end

post '/follow' do
    Follow.new(userId: params[:followId], followerId: session[:id]).save
    where_user_came_from = "/user/#{params[:followName]}" || '/'
    redirect to where_user_came_from 
end

post '/unfollow' do
    Follow.where(userId: params[:followId], followerId: session[:id]).take.delete
    where_user_came_from = "/user/#{params[:followName]}" || '/'
    redirect to where_user_came_from 
end
