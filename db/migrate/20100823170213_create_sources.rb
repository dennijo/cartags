class CreateSources < ActiveRecord::Migration
  def self.up
    create_table :sources do |t|
      t.string :name, :null=>false
      t.string :url, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :sources
  end
end
