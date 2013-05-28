class AddUniqueEmailToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :unique_email, :text
  end

  def self.down
    remove_column :users, :unique_email
  end
end
