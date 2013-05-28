xml.instruct! :xml, :version=>"1.0"
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Recent Tags on CarTagPics.com")
    xml.link("http://www.cartagpics.com")
    xml.description("Recent Tags on CarTagPics.com")
    xml.language("en")
    for p in @pictures
      xml.item do
        xml.title("#{p.title}")
        xml.description(p.description)
        xml.author("#{p.user.profile.first_name} #{p.user.profile.last_name}")
        xml.pubDate(p.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
        xml.link(view_url(:id=>p.guid))
        xml.guid(view_url(:id=>p.guid))
      end
    end
  }
}