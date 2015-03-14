class CreateTweets < ActiveRecord::Migration

    def self.up
    create_table :tweets do |t|
        t.string :text
        t.string :owner
        t.integer :parent
        t.timestamps
        end
    end
    
    def self.down
        drop_table :tweets
    end
end