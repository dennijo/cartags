class PictureController < ApplicationController
  include Geokit::Geocoders
  
  def index
    @picture = Picture.find_by_guid(params[:id])
    unless @picture
      flash[:error] = "Sorry, an error has occurred."
      redirect_to :controller=>:main
      return
    end
    views = @picture.views
    unless session[:user_id] == @picture.user_id
      @picture.views = views+1
      @picture.save
    end
    @tags = @picture.tag_counts_on(:tags)
    @tags2 = Picture.tag_counts_on(:tags)
    @comment = Comment.new
    @height = Paperclip::Geometry.from_file(@picture.image.path(:large)).height.to_i + 10
    @width = Paperclip::Geometry.from_file(@picture.image.path(:large)).width.to_i + 10
    if session[:layout] == "mobile"
      @height = (@height-10)/1.5
      @width = (@width-10)/1.5
    end
    unless @height > 350
      @limit = 2
    else
      @limit = 3
    end
    if session[:user_id]
      @user = User.find(session[:user_id])
    end
    @other_pictures = Picture.find(:all,:conditions=>"title like '#{@picture.title.gsub("'",'')}'")
    if @other_pictures.nitems <= 1
      @other_pictures = Picture.tagged_with(@picture.tags,:any=>true,:order=>'RAND()')
    end
    if @other_pictures.nil? || @other_pictures == {} || @other_pictures.nitems <= 1
      if @picture.latitude && @picture.longitude
        @other_pictures = Picture.find(:all,:within=>50,:origin=>[@picture.latitude,@picture.longitude],:order=>'RAND()',:limit=>2)
      end
    end
    if @other_pictures.nil? || @other_pictures == {} || @other_pictures.nitems == 0
      @other_pictures = Picture.find(:all,:conditions=>"user_id = #{@picture.user_id}", :limit=>3,:order=>"views desc")
    end
    @zoom = 8
    #if session[:user_id] == @picture.user_id
      unless @picture.latitude && @picture.longitude
        @picture.latitude = 38.7681702
        @picture.longitude = -96.4503434
        @zoom = 2
      end
    #end
    unless version == "mobile"
      render :index
    else
      render :index_mobile
    end
  end

  def delete
    @picture = Picture.find_by_guid_and_user_id(params[:id],session[:user_id])
    unless @picture
      flash[:error] = "Sorry, an error has occurred."
      redirect_to :back
      return
    end
    @picture.destroy
    flash[:success] = "The picture has been deleted."
    redirect_to :controller=>:main
    return
  end

  def rotate
    @picture = Picture.find_by_guid_and_user_id(params[:id],session[:user_id])
    unless @picture
      flash[:error] = "Sorry, an error has occurred."
      redirect_to :back
      return
    end
    @picture.rotate(90)
    flash[:success] = "The image will rotate shortly.  Please wait for a minute and refresh this page by <a href='#{view_url(@picture.guid)}'>clicking here</a>."
    redirect_to view_url(@picture.guid), :status=>"302"
    return
  end

  def edit_title
    @picture = Picture.find_by_guid_and_user_id(params[:id],session[:user_id])
    if @picture
      @picture.title = params[:value]
      @picture.save
      render :json => @picture.title
      return
    end
    render :json => nil
    return
  end

  def edit_description
    @picture = Picture.find_by_guid_and_user_id(params[:id],session[:user_id])
    if @picture
      @picture.description = params[:value]
      @picture.save
      render :json => @picture.description.gsub("\n",'<br/>')
      return
    end
    render :json => nil
    return
  end

  def edit_tags
    @picture = Picture.find_by_guid_and_user_id(params[:id],session[:user_id])
    if @picture
      @picture.tag_list = params[:value]
      @picture.save
      render :json => @picture.tag_list.to_s
      return
    end
    render :json => nil
    return
  end

  def update_location
    @picture = Picture.find_by_guid_and_user_id(params[:picture][:id],session[:user_id])
    if @picture
      @picture.latitude = params[:picture][:latitude]
      @picture.longitude = params[:picture][:longitude]
      @picture.save
      @picture.send_later(:get_city_state_zip_county)
      redirect_to view_url(:id=>@picture.guid), :status=>"302"
      return
    end
    flash[:error] = "An error has occurred"
    redirect_to :controller=>:main
  end

  def rate
    user = User.find(session[:user_id])
    @picture = Picture.find(params[:id])
    @picture.rate(params[:stars], user, params[:dimension])
    render :update do |page|
      page.replace_html @picture.wrapper_dom_id(params), ratings_for(@picture, params.merge(:wrap => false))
      page.visual_effect :highlight, @picture.wrapper_dom_id(params)
    end
  end

  def force_tod
    user = User.find(session[:user_id])
    picture = Picture.find_by_id(params[:id])
    if picture && user.superuser
      if picture.tod
        picture.tod = false
        picture.save
        render :partial => 'picture/make_tod',:locals=>{:picture=>picture}
      else
        picture.tod = true
        picture.save
        render :partial => 'picture/cancel_tod',:locals=>{:picture=>picture}
      end
    else
      render :text => ''
    end
  end

end
