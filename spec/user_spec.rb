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

end
