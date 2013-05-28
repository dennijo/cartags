class BitlyAdapter
  
  def initialize

    login = BITLY_API_LOGIN
    api_key = BITLY_API_KEY

    authorize = UrlShortener::Authorize.new login,api_key
    @client = UrlShortener::Client.new(authorize)

  end

  def stats(url)
    @client.stats(url)
  end

  def expand(url)
    @client.expand(url)
  end

  def info(url)
    @client.info(url)
  end
  
  def shorten(url)
    unless /^http:/.match(url)
      url = "http://#{url}"
    end
    if url.match('http://bit.ly/')
      return url
    end
    begin
      shorten = @client.shorten(url)
    rescue Exception => e
      return url
    end

    return shorten.shortUrl

  end

end