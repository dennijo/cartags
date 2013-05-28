class TagOfTheDay
  include Geokit::Geocoders
  
  def initialize

  end

  def perform
    today = 24.hours.ago.utc
    pod = Picture.find(:first,:conditions=>" tod=1 ")
    unless pod
      pod = Picture.find(:first,:conditions=>"created_at >= '#{today.to_s(:db)}%'",:order=>"views,rating_average")
    end
    unless pod
      pod = Picture.find(:first,:order=>'RAND()')
    end
    if pod
      begin
        res = MultiGeocoder.reverse_geocode([pod.latitude,pod.longitude])
        city = res.city
        state = res.state
      rescue Exception => e
        city = nil
        state = nil
        puts "Error getting reverse geocode: #{e}"
      end
      status = "Today's Tag of the day comes from #{pod.user.profile.first_name}, #{pod.title}"
      if city
        status += " found in #{city}"
      end
      if state
        status += ", #{state}"
      end
      v_url = 'http://www.cartagpics.com/view/'+pod.guid
      begin
        url = BitlyAdapter.new.shorten(v_url)
      rescue Exception => e
        url = v_url
        puts "Error getting short URL: #{e}"
      end
      fb_status = status
      status += " #{url}"
      tomorrow = 24.hours.from_now.getutc
      unless RAILS_ENV == 'development'
        t_oauth = Twitter::OAuth.new(TWITTER_API_KEY,TWITTER_CONSUMER_SECRET,:sign_in=>false)
        t_oauth.authorize_from_access(TWITTER_ACCESS_TOKEN,TWITTER_ACCESS_SECRET)
        Twitter::Base.new(t_oauth).update(status, {})
      else
        puts "I would post #{status}"
      end
      thumb_url = 'http://www.cartagpics.com/'+pod.image.url(:thumb)[1,pod.image.url(:thumb).length]
      options = {:type=>'feed',:link=>url,:description=>pod.description,:caption=>'CarTagPics : Every tag has a story',
        :picture=>thumb_url,:name=>pod.title,:message=>"#{fb_status}"}
      begin
        unless RAILS_ENV == "development"
          fb_token = FacebookAdapter.new(User.find(1)).get_page_access_token
          MiniFB.post(fb_token, FB_PAGE_ID, options)
        else
          print "I would post to FB, except this is a development environment #{options.to_s}"
        end
      rescue Exception => e
        Emailer.send_later(:deliver_error,"Error posting to Facebook: #{e}")
        #logger.error "Error posting to Facebook: #{e}"
      end

      pod.tod = false
      pod.save
      pods = Picture.find(:all,:conditions=>"tod = 1")
      pods.each {|p|
        p.tod = false
        p.save
      }
    end
    Delayed::Job.enqueue TagOfTheDay.new(),5,tomorrow
  end

end