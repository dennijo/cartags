class Profile < ActiveRecord::Base
  belongs_to :user
  before_create :create_unique_email_address
  

  def create_unique_email_address
    user = User.find(self.user_id)
    user.unique_email = self.first_name.downcase + '.' + rand(36**4).to_s + '@cartagpics.com'
    user.save
  end
  
end
