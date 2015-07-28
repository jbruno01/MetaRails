require 'uri'


  class Params

    attr_accessor :params

    def initialize(req, route_params = {})
      @params = {}
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

    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
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

    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
