class FacebookAdapter
  
  def initialize(user)
    @fb_access_token = user.fb_access_token    
  end

  def get_page_access_token
    accts = MiniFB.get(@fb_access_token,'me/accounts')
    for acct in accts.data
      if acct.id == FB_PAGE_ID
        return acct.access_token
      end
    end
    return nil
  end

end