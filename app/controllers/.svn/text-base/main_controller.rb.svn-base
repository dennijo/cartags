class MainController < ApplicationController
  include Geokit::Geocoders

  def index
    unless version == "mobile"
      limit = 8
      random_limit = 8
    else
      limit = 3
      random_limit = 0
    end
    unless version == "mobile"
      unless session[:lat] && session[:long] && session[:city] && session[:state]
        begin
          ip = request.remote_ip
          unless ip == '127.0.0.1'
            location = Geokit::Geocoders::MultiGeocoder.geocode(ip)
            lat = location.lat
            lon = location.lng
            res = MultiGeocoder.reverse_geocode([lat,lon])
            @city = res.city
            @state = res.state
          else
            lat = 33.5206608
            lon = -86.80249
            res = MultiGeocoder.reverse_geocode([lat,lon])
            @city = res.city
            @state = res.state
          end
        rescue Exception => e
          lat = 33.5206608
          lon = -86.80249
          @city = "Birmingham"
          @state = "AL"
          logger.error "Couldn't get IP or geocode: #{e}"
        end
      else
        lat = 33.5206608
        lon = -86.80249
        @city = "Birmingham"
        @state = "AL"
      end
      session[:lat] = lat
      session[:lon] = lon
      session[:city] = @city
      session[:state] = @state
    else
      lat = session[:lat]
      lon = session[:lon]
      @city = session[:city]
      @state = session[:state]
    end
    @close_pictures = Picture.find(:all,:within=>50,:origin=>[lat,lon],:order=>"created_at desc,views,rating_average",:limit=>random_limit)
    @recent_pictures = Picture.find(:all,:order=>"created_at desc",:limit=>limit)
    #@popular_pictures = Picture.find(:all,:order=>"views desc", :limit=>limit)
    @random_pictures = Picture.find(:all,:order=>"RAND() DESC", :limit=>limit)
    @total_pictures = Picture.count
    @tags = Picture.tag_counts_on(:tags)

    @st = 'USA'
    sql = "select count(*) as hits,state from pictures where state is not null group by state order by state"
    @hits = Picture.find_by_sql(sql)

    unless version == "mobile"
      render :index
    else
      render :index_mobile
    end
  end

  def error

  end

  def set_layout
    session[:layout] == "mobile" ? session[:layout] = "web" : session[:layout] = "mobile"
    redirect_to request.referrer
  end
  
end
