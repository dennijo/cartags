class PostToSocialNetworks
  
  def initialize(pic_id,message,fb=true,twitter=true)
    @picture = Picture.find(pic_id.to_i)
    @message = message
    @post_to_fb = fb
    @post_to_twitter = twitter
  end

  def perform
    v_url = 'http://www.cartagpics.com/view/'+@picture.guid
    begin
      url = BitlyAdapter.new.shorten(v_url)
    rescue Exception => e
      url = v_url
      puts "Error getting short URL: #{e}"
    end
    if @post_to_twitter
      unless RAILS_ENV == 'development'
        t_oauth = Twitter::OAuth.new(TWITTER_API_KEY,TWITTER_CONSUMER_SECRET,:sign_in=>false)
        t_oauth.authorize_from_access(TWITTER_ACCESS_TOKEN,TWITTER_ACCESS_SECRET)
        Twitter::Base.new(t_oauth).update(@message+" #{url}", {})
      else
          puts "I would post #{@message} #{url}"
      end
    end
    if @post_to_fb
      thumb_url = 'http://www.cartagpics.com/'+@picture.image.url(:thumb)[1,@picture.image.url(:thumb).length]
      options = {:type=>'feed',:link=>url,:description=>@picture.description,:caption=>'CarTagPics : Every tag has a story',
        :picture=>thumb_url,:name=>@picture.title,:message=>"#{@message}"}
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
    end
  end

end