require 'rss'
require 'open-uri'
require 'net/http'
require 'uri'
require 'sys'

RELEASE_TITLE = /Ruby (\d+\.\d+\.\d+) Released/
KNOWN_VERSIONS_FILE = ARGV[0]
RECIPIENTS = ENV['RECIPIENTS'].split(',').map{ |r| r.strip }

def get_versions_from_rss
    versions = []
    # retrieve versions from RSS
    url = 'https://www.ruby-lang.org/en/feeds/news.rss'
    URI.open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
            #puts "Item: #{item.title}"
            item.title.match(RELEASE_TITLE) { |m| 
                versions << m.captures[0].strip
            }
        end
    end

    #puts versions
    versions
end

def read_known_versions
    return [] unless File.exists?(KNOWN_VERSIONS_FILE)
    File.readlines(KNOWN_VERSIONS_FILE).map { |v| v.strip }
end

def match_versions(known_versions, versions)
    unknown_versions = []
    # find new versions
    versions.each { |v|
        unless known_versions.include?(v) 
            unknown_versions << v 
        end
    }
    unknown_versions
end

def write_unknown_versions(known_versions, unknown_versions)
    unless unknown_versions.empty?
        File.open(KNOWN_VERSIONS_FILE, 'w') { |file| 
            known_versions.each { |v|
                file.write("#{v}\n") 
            }
            unknown_versions.each { |v|
                file.write("#{v}\n") 
            }
        }
    end
end

def process_unknown_version(version) 
    puts version

    url = URI(ENV['MAILGUN_URL'])
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth 'api', ENV['MAILGUN_API_KEY']
    # req.use_ssl = true
    data = {
        'from' => "Ruby <ruby@#{ENV['MAILGUN_SERVER']}>",
        'subject' => "Ruby version #{version} released",
        'text' => "New ruby version #{version} released on https://ruby-lang.org"
    }
    data = data.merge RECIPIENTS.map{ |r| ['to', r] }.to_h
    req.set_form_data(data)
    sock = Net::HTTP.new(url.host, url.port)
    sock.use_ssl = true
    response = sock.start {|http| http.request(req) }
    sys.exit(1) unless response.kind_of? Net::HTTPSuccess
end


versions = get_versions_from_rss
known_versions = read_known_versions
unknown_versions = match_versions(known_versions, versions)

unknown_versions.each { |v| 
    process_unknown_version(v)
}

write_unknown_versions(known_versions, unknown_versions)
