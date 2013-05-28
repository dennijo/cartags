class AddAccessTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_access_token, :text
  end

  def self.down
    drop_column :users, :fb_access_token
  end
end
