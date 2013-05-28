class UploadController < ApplicationController
  def index
    if session[:user_id]
      @picture = Picture.new
      @user = User.find(session[:user_id])
    else
      flash[:error] = "You must first login before you can upload.  Please click on the 'Login with Facebook' button in the upper right hand corner"
      redirect_to :controller=>:main
      return
    end
    ip = request.remote_ip
    unless ip == '127.0.0.1'
      location = Geokit::Geocoders::MultiGeocoder.geocode(ip)
      @lat = location.lat
      @lon = location.lng
    else
      @lat = 33.5206608
      @lon = -86.80249
    end
    unless session[:layout] == "mobile"
      render :index
    else
      render :index_mobile
    end
  end

  def create
    begin
      @picture = Picture.create( params[:picture] )
    rescue Exception => e
      flash[:error] = "An error has occurred"
      redirect_to :controller=>:main
      return
    end
    if params[:auto_post_facebook] == "true"
      @picture.post_to_fb
    end
    flash[:success] = "Success"
    redirect_to view_url(:id=>@picture.guid)
    return
  end
end
