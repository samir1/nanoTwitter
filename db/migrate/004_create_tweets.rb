class CreateTweets < ActiveRecord::Migration

    def self.up
        create_table :tweets do |t|
            t.string :text
            t.integer :ownerId
            t.integer :parentTweetId
            t.timestamps :null => false
        end
    end

    def self.down
        drop_table :tweets
    end
end
