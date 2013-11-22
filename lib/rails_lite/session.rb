require 'json'
require 'webrick'

class Session
  def initialize(req)
    @req = req
    @session = {}
    @req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @session = JSON.parse(cookie.value)
      end
    end     
  end

  def [](key)
    @session[key]
  end

  def []=(key, val)
    @session[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', JSON(@session))
  end
  
end
