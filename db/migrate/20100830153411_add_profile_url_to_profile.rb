class AddProfileUrlToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :profile_url, :string
  end

  def self.down
    remove_column :profiles, :profile_url
  end
end
