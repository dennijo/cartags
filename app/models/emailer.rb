class Emailer < ActionMailer::Base

  def contact(name,email,subject,message)
    @recipients   = 'cartagpics@gmail.com'
    @from         = email
    @subject      = name + ": " + subject
    @sent_on      = Time.now
    @content_type = "text/html"
    @body[:message]  = message
  end

  def welcome(user)
    @recipients   = user.profile.email
    @from         = 'CarTagPics <no-reply@cartagpics.com>'
    @subject      = 'Welcome to CarTagPics'
    @sent_on      = Time.now
    @content_type = "text/html"
    @body[:message]  = ''
    @user = user
  end

  def comment(pic,com)
    @recipients = pic.user.profile.email
    @from = com.user.profile.first_name+' '+com.user.profile.last_name+ "<#{com.user.profile.email}>"
    @bcc = "cartagpics@gmail.com"
    @subject = "Comment on CarTagPics.com"
    @sent_on = Time.now
    @content_type = "text/html"
    @body[:message] = "#{com.user.profile.first_name} #{com.user.profile.last_name} commented on #{pic.title}.  <a href=\"http://www.cartagpics.com/view/#{pic.guid}\">View the comment</a>"
  end

  def comment_cc(pic,com)
    @recipients = com.user.profile.email
    @from = "CarTagPics.com <no-reply@cartagpics.com>"
    @subject = "Comment on CarTagPics.com"
    @sent_on = Time.now
    @content_type = "text/html"
    @body[:message] = "#{com.user.profile.first_name} #{com.user.profile.last_name} commented on #{pic.title}.  <a href=\"http://www.cartagpics.com/view/#{pic.guid}\">View the comment</a>"
  end

  def upload(pic)
    @recipients = "cartagpics@gmail.com,josh@joshdennis.net"
    @from = "CarTagPics.com <no-reply@cartagpics.com>"
    @subject = "New tag uploaded to CarTagPics.com"
    @sent_on = Time.now
    @content_type = "text/html"
    @body[:message] = "#{pic.title} uploaded by #{pic.user.profile.first_name} #{pic.user.profile.last_name}.  <a href=\"http://www.cartagpics.com/view/#{pic.guid}\">View Tag</a>."
  end

  def new_user(user)
    @recipients = "cartagpics@gmail.com,josh@joshdennis.net"
    @from = "CarTagPics.com <no-reply@cartagpics.com>"
    @subject = "New user on CarTagPics.com"
    @sent_on = Time.now
    @content_type = "text/html"
    @body[:message] = "#{user.profile.first_name} #{user.profile.last_name} <#{user.profile.email}> is now a user on CarTagPics.com."
  end

  def test(to,message)
    @recipients = to
    @from = "CarTagPics.com <no-reply@cartagpics.com>"
    @subject = "Test Message"
    @sent_on = Time.now
    @content = "text/html"
    @body[:message] = message
  end

  def error(message)
    @recipients = 'josh@joshdennis.net'
    @from = "CarTagPics.com <no-reply@cartagpics.com>"
    @subject = "Error on CarTagPics.com"
    @sent_on = Time.now
    @content = "text/html"
    @body[:message] = message
  end

end
