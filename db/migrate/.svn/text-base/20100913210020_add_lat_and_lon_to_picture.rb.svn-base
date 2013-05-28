class AddLatAndLonToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures,:latitude, :decimal, :precision => 15, :scale => 10
    add_column :pictures,:longitude, :decimal, :precision => 15, :scale => 10
  end

  def self.down
    remove_column :pictures,:latitude
    remove_column :pictures,:longitude
  end
end
