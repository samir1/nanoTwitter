require 'rubygems'
require 'sinatra'
require 'active_record'
require 'sinatra/activerecord'


ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database =>  'sinatra_application.sqlite3.db'
)

configure do
  enable :sessions
end

helpers do
  def username
    session[:identity] ? session[:identity] : 'Login'
  end
end

before '/secure/*' do
  if !session[:identity] then
    session[:previous_url] = request.path
    @error = 'Must be logged into to visit ' + request.path
    halt erb(:login_form)
  end
end

get '/' do
  erb :main
end

get '/login/form' do 
  erb :login_form
end

post '/login/attempt' do
  session[:identity] = params['username']
  where_user_came_from = session[:previous_url] || '/'
  redirect to where_user_came_from 
end

get '/logout' do
  session.delete(:identity)
  erb "<div class='alert alert-message'>Logged out</div>"
end


get '/secure/place' do
  erb "Only <%=session[:identity]%> can access this page"
end
