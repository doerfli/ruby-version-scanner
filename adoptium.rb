require 'rss'
require 'open-uri'
require 'net/http'
require 'uri'
require 'json'

def get_openjdk_versions
    versions = []
    # retrieve versions from adoptium api
    url = URI("https://api.adoptium.net/v3/info/release_names?architecture=x64&heap_size=normal&image_type=jdk&jvm_impl=hotspot&os=linux&page=0&page_size=20&project=jdk&release_type=ga&sort_method=DEFAULT&sort_order=DESC&vendor=eclipse")
    req = Net::HTTP::Get.new(url.request_uri)
    sock = Net::HTTP.new(url.host, url.port)
    sock.use_ssl = true
    response = sock.start {|http| http.request(req) }
    body = JSON.parse(response.body)
    versions = body["releases"]
    versions.map{ |e| "OpenJDK #{e}"}
end
