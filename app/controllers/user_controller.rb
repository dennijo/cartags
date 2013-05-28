class UserController < ApplicationController
  require 'cgi'
  
  def index
  end

  def login
    cb_url = url_for(:action=>:callback)
    #puts "CALLBACK: #{cb_url}"
    unless version == "mobile"
      display = ''
    else
      display = 'touch'
    end
    @oauth_url = MiniFB.oauth_url(FB_APP_ID, # your Facebook App ID (NOT API_KEY)
                            cb_url, # redirect url
                            {:scope=>'offline_access,user_about_me,user_birthday,email,user_location,publish_stream',:display=>display}) # This asks for all permissions

    if params[:pic]
      session[:next] = view_url(:id=>params[:pic])
    end
    redirect_to @oauth_url,:status=>303
  end

  def logout
    session[:user_id] = nil
    layout = session[:layout]
    session.clear
    session[:layout] = layout
    redirect_to :controller => :main
  end

  def callback

    cb_url = "http://#{request.host_with_port}/user/callback"
    access_token_hash = MiniFB.oauth_access_token(FB_APP_ID, cb_url, FB_APP_SECRET, params[:code])

    access_token = CGI::unescape(access_token_hash["access_token"])
    #logger.info("@access_token=#{access_token}")
    fb_user = MiniFB.get(access_token, 'me', :metadata => '1')
    #logger.info("ME: #{fb_user.inspect}")

    user = User.find_by_external_id fb_user.id
    if user
      session[:user_id] = user.id
      if user.superuser
        session[:superuser] = true
        session[:orig_user_id] = user.id
      end
      if user.profile
        profile = user.profile
      else
        profile = Profile.new
        profile.user_id = user.id
      end
      profile.first_name = fb_user.first_name
      profile.last_name = fb_user.last_name
      profile.email = fb_user.email
      profile.profile_url = fb_user.link
      profile.save
      user.fb_access_token = access_token
      user.save
    else
      source = Source.find_by_name 'Facebook'
      user = User.new
      user.external_id = fb_user.id
      user.source_id = source.id
      user.fb_access_token = access_token
      user.save
      profile = Profile.new
      profile.user_id = user.id
      #profile.dob =
      profile.first_name = fb_user.first_name
      profile.last_name = fb_user.last_name
      profile.email = fb_user.email
      profile.profile_url = fb_user.link
      #profile.location
      profile.save
      session[:user_id] = user.id
    end
    session[:fb_access_token] = access_token
    unless session[:next]
      redirect_to :controller=>:main
      return
    else
      redirect_to session[:next]
      session[:next] = nil
      return
    end
  end

  def tags
    page = params[:page] || 1
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    @pictures = Picture.paginate_all_by_user_id(session[:user_id],:order=>"created_at desc",:page=>page,:per_page=>per_page)
    @tags = Picture.tag_counts_on(:tags)

    unless version == "mobile"
      render :tags
    else
      render :tags_mobile
    end
  end

  def view
    per_page = 20
    page = params[:page] || 1
    user = User.find_by_external_id(params[:id])
    unless user
      flash[:error] = "Sorry, an error has occurred."
      redirect_to :controller=>:main
      return
    else
      if request.format.html?
        @pictures = Picture.paginate_all_by_user_id(user.id,:page=>page,:per_page=>per_page)
        @tags = Picture.tag_counts_on(:tags)
        @total_tags = Picture.count(:conditions=>"user_id = #{user.id}")
      else
        @pictures = Picture.find_all_by_user_id(user.id)
      end
    end
    respond_to do |format|
      format.html # view.html.erb
      format.rss  { render :layout => false }
    end
  end

  def admin
    if session[:superuser] && params[:id]
      p = Picture.find(params[:id])
      if p.user_id == session[:user_id]
        session[:user_id] = session[:orig_user_id]
      else
        session[:user_id] = p.user_id
      end
      redirect_to view_url(p.guid),:status=>"302"
      return
    else
      redirect_to :controller=>:main, :status=>"302"
      return
    end
  end

  def reset_unique_email
    user = User.find(session[:user_id])
    if user
      user.profile.create_unique_email_address
      user = User.find(session[:user_id])
      render :text=> user.unique_email
    else
      render :text=>''
    end
  end
  
end
