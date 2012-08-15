require 'rubygems'
require 'sinatra'
require 'ruty'
require 'json'
require "net/http"

@@loader = nil

# this gets called before each request is processed
before do
  # create Ruty template engine instance
  @@loader = Ruty::Loaders::Filesystem.new(:dirname => './views') if @@loader == nil

  # Strip the last / from the path
  request.env['PATH_INFO'].gsub!(/\/$/, '')
end

# temperature log
get '/sensornet/temperature.php' do
  ret = "Logging temperature #{request.params['temperature']} for device #{request.params['deviceid']}"
  t = request.params['temperature']
  temp = "#{t[12..15]}".to_i(base=16) - "#{t[16..19]}".to_i(base=16)
  temp = temp / 100.0
  data = {
    "version" => "1.0.0",
    "datastreams" => [
        { "id" => request.params['deviceid'], "current_value" => temp }
    ]
  }
  post_cosm("71130", data.to_json)
end

# sample landing page
get '' do
  data = {
    :events => [ 
        { :uri => 1, :name => "Test event 1" }, 
        { :uri => 2, :name => "Test event 2" } 
    ]
  }

  do_render :index, data
end

private

# render templates
def do_render(template, obj)
    # add global template variables
    obj = { :root => @env['SCRIPT_NAME'] + "/", :mxit => @mxit }.merge obj 
    # use ruty to render templates from symbol name
    @@loader.get_template(template.to_s + ".html").render(obj)
end

def post_cosm(feed_id, json_data)
    begin
      http = Net::HTTP.new('api.cosm.com', 80)
      response = ""
      http.start do |http|
        req = Net::HTTP::Put.new("/v2/feeds/#{feed_id}", {'X-ApiKey' => '3QXRsL5yUxn5KF3mGPlmsO2JFYOSAKxZQWpRV1pPTnFaVT0g'})
        req.body = json_data
        resp = http.request(req)
        response = resp.body
      end
      ret = "Submitted to Cosm: #{response}"
    rescue
      # Probably not much we can do, lets hope that the next one works
      ret = "Problem submitting results to Cosm. Error reported was: #{$!}"
    end
    ret
end
