class ContactController < ApplicationController
  def index
  end

  def submit

    flash[:error] = ""

    # get params
    name = params[:name]
    if name.blank?
      flash[:error] += "Sorry, name must be included"
    end
    email = params[:email]
    if email.blank?
      flash[:error] += "<br/>Sorry, email must be included"
    end
    subject = params[:subject]
    if subject.blank?
      flash[:error] += "<br/>Sorry, subject must be included"
    end
    message = params[:message]
    if message.nil?
      flash[:error] += "<br/>Sorry, message must be included"
    end

    if flash[:error].blank? && verify_recaptcha()
      #Emailer.deliver_contact(name,email,subject,message)
      Emailer.send_later(:deliver_contact,name,email,subject,message)
      flash[:error] = nil
      flash[:success] = "Your message has been sent.  Thanks for your input."
      redirect_to :controller=>:main
      return
    else
      unless verify_recaptcha()
        flash[:error] += "<br/>Error, the reCAPTCHA was incorrect."
      end
      redirect_to :controller=>:contact, :name=>params[:name],:email=>params[:email],:subject=>params[:subject],:message=>params[:subject]
    end
  end

end
