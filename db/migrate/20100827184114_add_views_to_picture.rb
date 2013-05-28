class AddViewsToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :views, :integer, :default=>0
  end

  def self.down
    remove_column :pictures, :views
  end
end
