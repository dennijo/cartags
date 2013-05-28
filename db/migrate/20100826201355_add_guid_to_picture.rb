class AddGuidToPicture < ActiveRecord::Migration
  def self.up
    add_column :pictures, :guid, :string
    execute "Create unique index unique_guid on pictures (guid)"
  end

  def self.down
    execute "Drop index unique_guid on pictures"
    remove_column :pictures, :guid
  end
end
