class AddFacebookAsSource < ActiveRecord::Migration
  def self.up
    s = Source.new
    s.name = 'Facebook'
    s.url = 'http://connect.facebook.com'
    s.save
  end

  def self.down
    s = Source.find_by_name 'Facebook'
    s.destroy
  end
end
