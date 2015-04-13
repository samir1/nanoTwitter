require 'minitest/autorun'
require 'rspec'
require 'rack/test'
require_relative '../app'

  def app 
    Sinatra::Application
  end

describe "Tweets", "a simple tweet example" do
	include Rack::Test::Methods

    before do
    User.delete_all
    Tweet.delete_all
    end

    let(:user) { User.new(name: "mike",
                username: "tester",
                email: "test@email.address",
                password: "strongpass")}
 

    describe "POST on /tweet" do
    
        it "should let a user tweet" do
            post('/user/register/attempt',
                    { :name => user.name,
                    :username => user.username,
                    :email => user.email,
                    :password => user.password})
                    
                last_response.status.must_equal 302
                founduser= User.where(username: user.username).take
            post('/tweet', 
            { :tweet => "test tweet example text for posting"})
    last_response.status.must_equal 302
    tweet=Tweet.where(owner=founduser.id).first
    tweet.text.must_equal "test tweet example text for posting" 
  end 

  it "should not let a user tweet if theyre not logged in" do
              post('/user/register/attempt',
                    { :name => user.name,
                    :username => user.username,
                    :email => user.email,
                    :password => user.password})
                    
                last_response.status.must_equal 302
                founduser= User.where(username: user.username).take
                get '/logout'
        post('/tweet', 
        { :tweet => "test tweet example text for not logged in"})
    last_response.status.must_equal 400
    end
    
  end
  
  describe "DELETE on /delete/tweet" do

  it "should delete a tweet" do
    post('/user/register/attempt',
                    { :name => user.name,
                    :username => user.username,
                    :email => user.email,
                    :password => user.password})
                    
                last_response.status.must_equal 302
                founduser= User.where(username: user.username).take
            post('/tweet', 
            { :tweet => "test tweet example text for deleting"})
    last_response.status.must_equal 302
    tweet=Tweet.where(owner=founduser.id).first
    tweet.text.must_equal "test tweet example text for deleting"
  	delete('/delete/tweet', {:id => tweet.id})
  	last_response.status.must_equal 200
  	Tweet.where(owner=user.id).first.must_equal nil
  end
  end
    
end