class SetTweetCharacterLimit < ActiveRecord::Migration
	def self.up
        change_column :tweets, :text, :string, :limit => 140
    end
end