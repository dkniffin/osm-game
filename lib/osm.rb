require 'net/http'

module OSMImporter
  extend self
  def import(bbox)
    options = { bbox: bbox, timeout: 900, element_limit: 1073741824, json: true }

    uri = URI('http://overpass-api.de/api/interpreter')

    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = false
    req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
    req.body = query(bbox)
    res = https.request(req)
    hash = JSON.parse(res.body)
    puts hash
  end

  private

  def query(bbox)
    bbox_string = "#{bbox[:s]},#{bbox[:w]},#{bbox[:n]},#{bbox[:e]}"
    "(node(#{bbox_string});<;);out;"
  end
end
