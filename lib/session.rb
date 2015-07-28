require 'json'
require 'webrick'


  class Session

    def initialize(req)
      @temp = {}
      req.cookies.each do |cookie|
        if cookie.name == "_rails_lite_app"
          @temp = JSON.parse(cookie.value)
        end
      end
    end

    def [](key)
      @temp[key]
    end

    def []=(key, val)
      @temp[key] = val
    end

    def store_session(res)
      cracker = WEBrick::Cookie.new("_rails_lite_app", @temp.to_json)
      res.cookies << cracker
    end
  end
