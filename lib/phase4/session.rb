require 'json'
require 'webrick'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
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

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cracker = WEBrick::Cookie.new("_rails_lite_app", @temp.to_json)
      res.cookies << cracker
    end
  end
end
