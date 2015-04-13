require "minitest/autorun"
require 'rspec'
require 'rack/test'
require_relative "../app"

  def app 
    Sinatra::Application
  end
  
  describe "App", "a simple nanotwitter app" do
  include Rack::Test::Methods
  
  it "will view the root page" do
  
  end
  
  end
