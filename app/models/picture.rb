class Picture < ActiveRecord::Base
  belongs_to :user
  has_attached_file :image, :styles => {
    :large=>{
      :processors=>[:watermark],:geometry=>"500x500>",:watermark_path=>"#{RAILS_ROOT}/public/images/watermark.png",:position=>"Southeast"},
    :thumb => {
      :geometry=>"150x150#"}
    }
  has_many :comment
  before_create :create_file_name
  acts_as_taggable
  acts_as_mappable :default_units => :miles,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude
  ajaxful_rateable :stars => 5, :cache_column=>:rating_average
  include Geokit::Geocoders

  after_create :auto_orient
  after_create :email_notification
  after_create :get_city_state_zip_county

  def rotate(degrees = 90)

    image_path = self.image.path
    image = Magick::ImageList.new(image_path)
    image.rotate!(degrees)
    image.write(image_path)

    self.image.reprocess!            
    FileUtils.chown_R 'nobody', 'nobody', "#{RAILS_ROOT}/public/system/images/#{self.id}"

    nil

  end
  handle_asynchronously :rotate

  def auto_orient
    begin
      image_path = self.image.path
      image = Magick::ImageList.new(image_path)
      image.auto_orient!
      image.write(image_path)
      self.image.reprocess!
      FileUtils.chown_R 'nobody', 'nobody', "#{RAILS_ROOT}/public/system/images/#{self.id}"
    rescue Exception => e      
    end
  end
  handle_asynchronously :auto_orient

  def get_city_state_zip_county
    unless self.latitude.nil? || self.longitude.nil?
      res = MultiGeocoder.reverse_geocode([self.latitude,self.longitude])
      self.city = res.city
      self.state = res.state
      self.zip = res.zip
      self.county = res.province
      self.save
    end
  end
  handle_asynchronously :get_city_state_zip_county

  def email_notification
    Emailer.deliver_upload(self)
  end
  handle_asynchronously :email_notification

  def post_to_fb
    v_url = 'http://www.cartagpics.com/view/'+self.guid
    begin
      url = BitlyAdapter.new.shorten(v_url)
    rescue Exception => e
      url = v_url
      Emailer.send_later(:deliver_error,"Error getting short URL: #{e}")
      #logger.error "Error getting short URL: #{e}"
    end
    thumb_url = 'http://www.cartagpics.com/'+self.image.url(:thumb)[1,self.image.url(:thumb).length]
    options = {:type=>'feed',:link=>url,:description=>self.description,:caption=>'CarTagPics : Every tag has a story',
      :picture=>thumb_url,:name=>self.title,:message=>"I just posted a new tag '#{self.title}' on CarTagPics.com."}
    begin
      unless RAILS_ENV == "development"
        MiniFB.post(self.user.fb_access_token, self.user.external_id, options)
      else
        print "I would post to FB, except this is a development environment"
      end
    rescue Exception => e
      Emailer.send_later(:deliver_error,"Error posting to Facebook: #{e}")
      #logger.error "Error posting to Facebook: #{e}"
    end
  end
  handle_asynchronously :post_to_fb

  private

  def create_file_name
    #guid = Guid.new
    guid = rand(36**8).to_s(36)
    extension = File.extname(image_file_name).downcase
    self.image.instance_write(:file_name, "#{guid}#{extension}")
    self.guid = guid.to_s
  end

end
