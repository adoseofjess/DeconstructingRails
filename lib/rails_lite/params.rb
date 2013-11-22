require 'uri'

class Params
  def initialize(req, route_params = {})
    @route_params = route_params
    
    if req.query_string.nil?
      @query_string = {}
    else
      @query_string = parse_www_encoded_form(req.query_string)
    end

    if req.body.nil? 
      @request_params = {}
    else
      @request_params = parse_www_encoded_form(req.body)
    end

    @params = @route_params.merge(@query_string).merge(@request_params)
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    hash_info = URI::decode_www_form(www_encoded_form)
# This is going to look like ["cat[name]"=>"Breakfast ", "cat[owner]"=>"Devon"]?
    
    hash_info.map do |pair|
      keys = parse_key(pair[0])
      # keys is going to look like ["cat", "name"], ["cat", "owner"]
      nest(keys, pair[1])
      # we passed in nest(["cat", "name"], "Breakfast")
      # it's supposed to look like {"cat": {"name": "Breakfast", "owner": "Devon"}}
    end
    
    Hash[hash_info]  
  end
  
# it'll look like nest([k1, k2, k3], v, {})
  def nest(keys, val, h = {})
    if keys.count == 1
      return h[keys.first] = val
    else
      h[keys.first] = nest(keys[1..-1], val)
    end
  end

# parse_key should return an array of keys all the way down the nesting. So parse_key("cat[name]") == ["cat", "name"]
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
