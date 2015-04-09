require "minitest/autorun"
require 'rspec'
require 'rack/test'
require_relative "../app"

  def app 
    Sinatra::Application
  end
  

describe "User", "A simple user example" do
include Rack::Test::Methods


    before do
    User.delete_all
    end

    let(:user) { User.new(name: "mike",
                username: "tester",
                email: "test@email.address",
                password: "strongpass")}
  
        
          it "has a name" do
            user.name.must_equal "mike"
          end
          
            it "has a username" do
           
            user.username.must_equal "tester"
          end
          
            it "has an email" do
              
                user.email.must_equal "test@email.address"
          end
          
            it "has a password" do
           
            user.password.must_equal "strongpass"
          end
          
          describe "POST on /user/register/attempt" do
            it "can register a new user" do
                post('/user/register/attempt',
                    { :name => "mike",
                    :username => "tester",
                    :email => "test@email.address",
                    :password => "strongpass"}.to_json)
                    
                last_response.status.must_equal 302
                founduser= User.all
                founduser.must_equal nil
            end
        end
          it "can follow other users"
          it "can unfollow users"
          it "can see last n tweets of followed users"
          it "can display n of a specific user's tweets"
          

end
