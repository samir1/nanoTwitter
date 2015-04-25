require 'rubygems'
require 'sinatra'
require 'active_record'
require './models/user'
require './models/tweet'
require './models/follow'
require 'faker'

# require 'sinatra/active_record'

# configure :production do
#   require 'newrelic_rpm'
# end

ActiveRecord::Base.logger = Logger.new(STDOUT)

configure do
    enable :sessions
    env = ENV["SINATRA_ENV"] || "development"
    databases = YAML.load(ERB.new(File.read("config/database.yml")).result)
    ActiveRecord::Base.establish_connection(databases[env])
    
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

get '/loaderio-2aee583d8cfdd329307e880970966129/' do
  "loaderio-2aee583d8cfdd329307e880970966129"
end

get '/loaderio-100947118e9efbf25b07a3bcb3568bb1/' do
  "loaderio-100947118e9efbf25b07a3bcb3568bb1"
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

delete '/delete/tweet' do
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
    @current_user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
    if @current_user.save
        session[:username] = params[:username]
        session[:name] = params[:name]
        session[:email] = params[:email]
        session[:id] = User.where(username: params[:username]).take.id
        redirect to "/user/profile"
    else
        erb :register
    end
end

#tweet
post '/tweet' do
    tweet = Tweet.new(text: params[:tweet], owner: session[:id])
    tweet.save!
    redirect to '/'
end

get '/tweets/all' do
    erb :alltweets
end

get '/user/:username' do
    if User.exists?(username: params[:username])
        erb :user
    else
        status 404
        erb :pagenotfound
    end
end

post '/follow' do
    Follow.new(user_id: params[:followId], follower_id: session[:id]).save
    where_user_came_from = "/user/#{params[:followName]}" || '/'
    redirect to where_user_came_from 
end

post '/unfollow' do
    Follow.where(user_id: params[:followId], follower_id: session[:id]).take.delete
    where_user_came_from = "/user/#{params[:followName]}" || '/'
    redirect to where_user_came_from 
end
