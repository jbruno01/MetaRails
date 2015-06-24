require 'uri'

module Phase5
  class Params

    attr_accessor :params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = {}
      # byebug
      query = req.query_string
      body = req.body
      return {} if query.nil? && body.nil? && route_params.nil?
      query.nil? ? query_params = {} : query_params = parse_www_encoded_form(query)
      body.nil? ? body_params = {} : body_params = parse_www_encoded_form(body)

      @params = query_params.merge!(body_params).merge!(route_params)
    end

    def [](key)
      @params[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      decoded = URI::decode_www_form(www_encoded_form)
      final_hash = {}
      decoded.each do |key, val|
        keys = parse_key(key)
        current_hash = nil

        keys.each_with_index do |keyx, ind|
          if keys.length == 1
            final_hash[keyx] = val
            break
          end

          if ind == 0
            final_hash[keyx] ||= {}
            current_hash = final_hash[keyx]
          elsif ind == keys.length - 1
            current_hash[keyx] = val
          else
            current_hash[keyx] ||= {}
            current_hash = current_hash[keyx]
          end
        end
      end
      final_hash
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
