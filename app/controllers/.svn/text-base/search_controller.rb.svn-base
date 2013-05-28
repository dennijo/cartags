class SearchController < ApplicationController
  def index
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    page = params[:page] || 1
    if params[:query] == 'Search'
      params[:query] = ''
    end
    @pictures = Picture.paginate_by_sql "select * from pictures where description like '%#{params[:query]}%' or title like '%#{params[:query]}%'",:page=>params[:page],:per_page=>per_page
#    (:conditions=>"description like '%params[:id]%' or title like '%params[:id]%'",:page=>params[:page],:per_page=>per_page)
    @tags = Picture.tag_counts_on(:tags)
    if @pictures.nitems == 0 && params[:query] && params[:query] != 'Search'
      flash[:warning] = "Sorry, your search yielded no results.  Please try again."
      #redirect_to :controller=>:main
      return
    end
    if @pictures.nitems == 1
      redirect_to view_url(:id=>@pictures.first.guid)
      return
    end

    unless version == "mobile"
      render :index
    else
      render :index_mobile
    end
  end

  def search_ajax
    ActiveRecord::Base.include_root_in_json = false

    @pictures = Picture.find_by_sql "select id,title as label, title as value from pictures where description like '%#{params[:query]}%' or title like '%#{params[:query]}%' group by id"

    respond_to do |format|
      #format.html # index.html.erb
      format.xml {render :xml=>@pictures}
      format.js {render :json=>@pictures}
    end
  end

  def tag
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    page = params[:page] || 1
    if request.format.html?
      @pictures = Picture.tagged_with(params[:id]).paginate(:order=>:created_at,:page => params[:page], :per_page => per_page)
      @tags = Picture.tag_counts_on(:tags)
      if @pictures.nitems == 0
        flash[:warning] = "Sorry, your search yielded no results.  Please try again."
        redirect_to :controller=>:main
        return
      end
      if @pictures.nitems == 1
        redirect_to view_url(:id=>@pictures.first.guid)
        return
     end
    else
      @pictures = Picture.tagged_with(params[:id]).paginate(:order=>:created_at,:page => params[:page], :per_page => per_page)
    end
    @title = "Tags tagged with #{params[:id]}"
    respond_to do |format|
      format.html { 
        unless version == "mobile"
          render :index
        else
          render :index_mobile
        end
        }
      format.rss  { render :layout => false }
    end
  end
  
  def browse
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    page = params[:page] || 1
    if request.format.html?
      @pictures = Picture.paginate(:all,:order=>"created_at desc",:page=>page,:per_page=>per_page)
      @tags = Picture.tag_counts_on(:tags)
      if @pictures.nitems == 0
        flash[:warning] = "Sorry, your search yielded no results.  Please try again."
        redirect_to :controller=>:main
        return
      end
    else
      @pictures = Picture.find(:all,:order=>"created_at desc")
    end
    @title = "Most Recent Tags"
    respond_to do |format|
      format.html {
        unless version == "mobile"
          render :index
        else
          render :index_mobile
        end
        }
      format.rss  { render :layout => false }
    end
  end

  def popular
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    page = params[:page] || 1
    if request.format.html?
      @pictures = Picture.paginate(:all,:order=>"views desc",:page=>page,:per_page=>per_page)
      @tags = Picture.tag_counts_on(:tags)
      if @pictures.nitems == 0
        flash[:warning] = "Sorry, your search yielded no results.  Please try again."
        redirect_to :controller=>:main
        return
      end
    else
      @pictures = Picture.find(:all,:order=>"views desc")
    end
    @title = "Most Popular Tags"
    respond_to do |format|
      format.html {
        unless version == "mobile"
          render :index
        else
          render :index_mobile
        end
        }
      format.rss  { render :layout => false }
    end
  end

  def tag_ajax
    ActiveRecord::Base.include_root_in_json = false
    q = params[:term]

    @tags = Tag.find_by_sql("Select id,name as label,name as value from tags where name like '#{q}%'")
    
    respond_to do |format|
      #format.html # index.html.erb
      format.xml {render :xml=>@tags}
      format.js {render :json=>@tags}
    end
  end

  def map
    per_page = 20
    page = params[:page] || 1
    if request.format.html?
      if params[:st].nil? || params[:st].blank?
        flash[:warning] = "Sorry, your search yielded no results.  Please try again."
        redirect_to :controller=>:main
        return
      end
      @pictures = Picture.paginate_by_sql "select * from pictures where state = '#{params[:st]}'",:page=>params[:page],:per_page=>per_page
      @tags = Picture.tag_counts_on(:tags)
      if @pictures.nitems == 0
        flash[:warning] = "Sorry, your search yielded no results.  Please try again."
        redirect_to :controller=>:main
        return
      end
      if @pictures.nitems == 1
        redirect_to view_url(:id=>@pictures.first.guid)
        return
      end
    else
      @pictures = Picture.paginate_by_sql "select * from pictures where state = '#{params[:st]}'",:page=>params[:page],:per_page=>per_page
    end

    @title = "Tags found within #{params[:name]}"
    respond_to do |format|
      format.html {
        unless version == "mobile"
          render :index
        else
          render :index_mobile
        end
        }
      format.rss  { render :layout => false }
    end
    
  end

  def advanced
    unless session[:layout] == "mobile"
      per_page = 20
    else
      per_page = 5
    end
    page = params[:page] || 1
    conditions = ""
    unless params[:title].nil? || params[:title].blank?
      conditions += "title like '%#{params[:title]}%' "
    end
    unless params[:desc].nil? || params[:desc].blank?
      conditions.blank? ? conditions += "description like '%#{params[:desc]}%'" : conditions += " and description like '%#{params[:desc]}%'"
    end
    unless params[:tag].nil? || params[:tag].blank?
      @pictures = Picture.tagged_with(params[:tag])
      ids = @pictures.collect {|p| p.id}
      ids = ids.join ','
      conditions.blank? ? conditions += " id in (#{ids})" : conditions += " and id in (#{ids})"
    end
    unless params[:radius].nil? || params[:zip].nil? || params[:radius].blank? || params[:zip].blank?
      @pictures = Picture.find(:all, :origin=>params[:zip], :within=>params[:radius])
      ids = @pictures.collect {|p| p.id}
      ids = ids.join ','
      conditions.blank? ? conditions += " id in (#{ids})" : conditions += " and id in (#{ids})"
    end
    unless params[:start_date].nil? || params[:start_date].blank?
      conditions.blank? ? conditions += " created_at >= '#{params[:start_date].to_date.to_s(:db)}'" : conditions += " and created_at >= '#{params[:start_date].to_date.to_s(:db)}'"
    end
    unless params[:end_date].nil? || params[:end_date].blank?
      conditions.blank? ? conditions += " created_at <= '#{params[:end_date].to_date.to_s(:db)}'" : conditions += " and created_at <= '#{params[:end_date].to_date.to_s(:db)}'"
    end
    if conditions.blank?
      conditions = "id = -1"
    end
    if conditions == " id in ()"
      conditions = "id = -242343"
    end
    @pictures = Picture.paginate_by_sql "select * from pictures where #{conditions}",:page=>params[:page],:per_page=>per_page
    @tags = Picture.tag_counts_on(:tags)
    if @pictures.nitems == 0 && conditions != "id = -1"
      flash[:warning] = "Sorry, your search yielded no results.  Please try again."
    end

    unless conditions == "id = -1"
      @title = "Advanced Search Results"
    end

    respond_to do |format|
      format.html {
        unless version == "mobile"
          render :index
        else
          render :index_mobile
        end
        }
      format.rss  { render :layout => false }
    end
  end

end
