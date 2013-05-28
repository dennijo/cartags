class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.integer :user_id, :null=>:false
      t.text :description
      t.string :location
      t.string :image_file_name, :null=>:false
      t.string :image_content_type, :null=>:false
      t.integer :image_file_size, :null=>:false
      t.datetime :image_updated_at, :null=>:false
      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
