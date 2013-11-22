require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

# should take the HTTPRequest and HTTPResponse objects as inputs - done
# Save the request and response objects to ivars - done
# it will use the request (its query string, cookies, body content) to help fill out the response

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req)
# Not sure about route_params, should be a hash? Already a hash?
    @route_params = route_params
  end

# parse request and constructs a session from it, cache in @session, use ||=
  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

# This needs to set the response status and header appropriately

  def redirect_to(url)
    return if @already_built_response 
    # @res.set_redirect(WEBrick::HTTPStatus::TemporaryRedirect, url) 
    # @res.header = "Location: #{url}"
    @res["location"] = url
    @res.status = 302
    session.store_session(@res)
    @already_built_response = true 
  end

  def render_content(content, type)
    return if @already_built_response
    @res.content_type = (type.to_s)
    @res.body = (content)
# Can you set instance variable to true?
    @already_built_response = true
  end

  def render(template_name)
    return if @already_built_response
    controller_name = self.class.to_s.underscore
    template = File.read("views/#{controller_name}/#{template_name}.html.erb")
    
    content = ERB.new(template).result(binding)
    render_content(content, @res.content_type)
    session.store_session(@res)
    @already_built_response = true
  end

  def invoke_action(name)
  end
end
