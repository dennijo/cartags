class User < ActiveRecord::Base
  has_one :profile
  has_many :picture
  has_many :comment
  ajaxful_rater
  after_create :send_new_user_notice
  after_create :send_welcome
  after_create :add_to_mailchimp

  def send_new_user_notice
    Emailer.send_later(:deliver_new_user,self)
  end

  def send_welcome
    Emailer.send_later(:deliver_welcome,self)
  end

  def add_to_mailchimp
    mc = Hominid::Base.new({:api_key=>MAILCHIMP_API_KEY})
    mc.subscribe(mc.find_list_id_by_name("CarTagPics List"), self.profile.email, {:FNAME => self.profile.first_name, :LNAME => self.profile.last_name}, {:email_type => 'html'})
  end
  handle_asynchronously :add_to_mailchimp

  def current_user
    if session[:user_id]
      return User.find(session[:user_id])
    else
      return nil
    end
  end

end
