require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative 'session'
require_relative 'params'


class ControllerBase
  attr_reader :req, :res, :params

  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
  end

  def already_built_response?
    @already_built_response ||= false
  end

  def redirect_to(url)
    if already_built_response?
      raise ExceptionError
    else
      @res.status = 302
      @res["location"] = url
      @already_built_response = true
      session.store_session(res)
    end
  end

  def render_content(content, content_type)
    if already_built_response?
      raise ExceptionError
    else
      @res.body = content
      @res.content_type = content_type
      @already_built_response = true
      session.store_session(res)
    end
  end

  def render(template_name)
    raise ExceptionError if already_built_response?
    contents = File.read("views/#{controller_name}/#{template_name.to_s}.html.erb")
    temp = ERB.new("<%= contents %>").result(binding)
    render_content(temp, "text/html")
  end

  def controller_name
    name = self.class.name.underscore
    name
  end

  def session
    @session ||= Session.new(req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?

    nil
  end

end
