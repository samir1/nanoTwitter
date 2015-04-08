require 'minitest/autorun'
require 'rspec'
require 'rack/test'
require_relative '../app'


describe "service" do
	include Rack::Test::Methods

  def app 
    Sinatra::Application
  end

  before(:all) do 
    User.delete_all
    User.create(name: "mike",
                username: "tester",
                email: "test@email.address",
                password: "strongpass")
                
  end


  it "should return a users tweets" do
    get '/api/v1/users/1/tweets' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes.first["text"].should == User.find(1).tweets.first.text
  end 

  it "should return a tweet based on the id" do
    get '/api/v1/tweets/1' 
    last_response.should be_ok
    attributes = JSON.parse(last_response.body) 
    attributes["text"].should == Tweet.find(1).text
  end

  it "should return the most recent tweets" do
  	get '/api/v1/tweets/recent/5'
  	last_response.should be_ok
	  attributes = JSON.parse(last_response.body)
    attributes[0]["id"].should == Tweet.all.count
  end

    it "should allow user to post tweet if logged in"
    it "should prevent non-logged in tweets"
end
