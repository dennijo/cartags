class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :external_id, :null=>false
      t.integer :source_id, :null=>false
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
