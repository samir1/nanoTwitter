class CreateFollows < ActiveRecord::Migration

    def self.up
    create_table :follows do |t|
        t.integer :userId
        t.integer :followerId
        t.timestamps
        end
    end
    
    def self.down
        drop_table :follows
    end
end
