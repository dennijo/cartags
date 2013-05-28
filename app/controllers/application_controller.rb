# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include Authentication
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :detect_browser
  
  layout :detect_browser
  
  def rescue_action(exception)
    respond_to do |format|
      format.html {

        flash[:exception] = exception
        logger.error(exception.backtrace.join("\n"))
        #Emailer.send_later(:deliver_error,exception.backtrace.join("<BR/>"))
        redirect_to error_url

      }
      format.xml  { render :xml => exception.message } # not sure this will work!
    end
  end

  def version
    if session[:layout]
      return session[:layout]
    else
      layout = :detect_browser
      unless layout == "cartagpics_mobile"
        return "web"
      else
        return "mobile"
      end
    end
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  private

  MOBILE_BROWSERS = ["android", "ipod", "opera mini", "blackberry", "palm","hiptop","avantgo","plucker", "xiino","blazer","elaine", "windows ce; ppc;", "windows ce; smartphone;","windows ce; iemobile", "up.browser","up.link","mmp","symbian","smartphone", "midp","wap","vodafone","o2","pocket","kindle", "mobile","pda","psp","treo"]
  MOBILE_LAYOUT = "cartagpics_mobile"
  WEB_LAYOUT = "cartagpics"

  def detect_browser
    session.inspect
    layout = selected_layout
    return layout if layout
    if request.headers && request.headers["HTTP_USER_AGENT"]
      agent = request.headers["HTTP_USER_AGENT"].downcase
      MOBILE_BROWSERS.each do |m|
        session[:layout] = "mobile" if agent.match(m)
        return MOBILE_LAYOUT if agent.match(m)
      end
    end
    session[:layout] = "web"
    return WEB_LAYOUT
  end

  def selected_layout
    session.inspect # force session load
    if session.has_key? :layout
      if session[:layout] == "mobile"
        return MOBILE_LAYOUT
      else
        return WEB_LAYOUT
      end
    end
    return nil
  end

end
