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
                    { :name => user.name,
                    :username => user.username,
                    :email => user.email,
                    :password => user.password})
                    
                last_response.status.must_equal 302
                founduser= User.where(username: user.username).take
                founduser.name.must_equal user.name
                founduser.email.must_equal user.email
            end
        end
        
        describe "POST on /login/attempt" do
            it "can log in with appropriatte credentials" do
            user.save
                post('/login/attempt', 
                {:username => user.username,
                 :password => user.password})
                 
            last_response.status.must_equal 302
            end
            
            it "cannot log in with invalid credentials" do
                user.save
                post('/login/attempt', 
                {:username => user.username,
                 :password => "wrongpassword"})
               
            last_response.status.must_equal 400
            end
        end

end
