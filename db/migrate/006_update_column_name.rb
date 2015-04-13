class UpdateColumnName < ActiveRecord::Migration
  def self.up
    rename_column :follows, :userId, :user_id
    rename_column :follows, :followerId, :follower_id
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end