class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.integer :user_id, :null=>false
      t.string :email
      t.string :first_name
      t.string :last_name
      t.date :dob
      t.string :location
      t.timestamps
    end
  end

  def self.down
    drop_table :profiles
  end
end
