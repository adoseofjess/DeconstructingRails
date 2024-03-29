require 'active_support/core_ext'
require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

# class MyController < ControllerBase
#   def go
#     render_content("hello world!", "text/html")
# 
#     # after you have template rendering, uncomment:
# #    render :show
# 
#     # after you have sessions going, uncomment:
# #    session["count"] ||= 0
# #    session["count"] += 1
# #    render :counting_show
#   end
# end

server.mount_proc '/' do |req, res|
  # MyController.new(req, res).go
  res.content_type = ('text/text')
  res.body = (req.path)
end

server.start