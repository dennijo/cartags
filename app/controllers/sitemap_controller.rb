class SitemapController < ApplicationController

  def index
    pages = Picture.all(:order => "updated_at desc")

    unless RAILS_ENV == 'development'
       host = request.host
    else
      host = request.host_with_port
    end
    @map = XmlSitemap::Map.new(host) do |m|
      m.add(:url => '/', :period => :hourly, :priority => 1.0)
      m.add(:url => '/search/browse', :period => :hourly, :priority => 1.0)
      pages.each do |p|
        m.add(
          :url => view_url(:id=>p.guid,:only_path=>true),
          :updated => p.updated_at,
          :priority => 0.8,
          :period => :daily
        )
      end
    end

    respond_to do |format|
      format.html { redirect_to :controller=>:main}
      format.xml  { render :xml => @map.render }
    end

  end

end
