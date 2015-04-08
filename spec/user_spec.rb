require "minitest/autorun"
require_relative "../app"

describe "User", "A simple user example" do

  let(:user) { User.new(:name => "mike", :username => "tester", :email => "test@email.address", :password => "strongpass") }
  
        
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
          
          it "can register a new account by giving a new name, email and password" do
            post '/user/register/attempt', {:name => user.name, :username => user.username, :email => user.email, :password => user.password}.to_json
            last_response.should be_ok
            session[:username].must_equal user.name
            session[:id].must_equal User.where(username: user.username).take.id
          end
          
          
          it "can follow other users"
          it "can unfollow users"
          it "can tweet"
          it "can see last n tweets of followed users"
          it "can display n of a specific user's tweets"
          

end
