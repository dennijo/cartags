class AddCityStateZipCountyToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :city, :string
    add_column :pictures, :state, :string
    add_column :pictures, :zip, :string
    add_column :pictures, :county, :string
  end

  def self.down
    remove_column :pictures, :city
    remove_column :pictures, :state
    remove_column :pictures, :zip
    remove_column :pictures, :county
  end
end
