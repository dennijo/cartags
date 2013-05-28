class SocialController < ApplicationController

  def index
    user = User.find(session[:user_id])
    unless user.superuser
      return
    end
    render :layout=>false
  end

  def submit
    user = User.find(session[:user_id])
    unless user.superuser
      return
    end
    Delayed::Job.enqueue PostToSocialNetworks.new(params[:picture_id],params[:message],params[:post_to_fb],params[:post_to_tw])
    render :text=>'<script type=text/javascript>this.window.close();</script>'
  end
  
end
