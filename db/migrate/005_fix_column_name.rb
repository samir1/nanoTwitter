class FixColumnName < ActiveRecord::Migration
  def self.up
    rename_column :follows, :userId, :userId
    rename_column :follows, :followerId, :followerId
  end

  def self.down
    # rename back if you need or do something else or do nothing
  end
end