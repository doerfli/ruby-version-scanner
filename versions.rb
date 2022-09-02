require 'net/http'
require 'uri'
require './ruby.rb'
require './adoptium.rb'
require './python.rb'

RELEASE_TITLE = /Ruby (\d+\.\d+\.\d+) Released/
KNOWN_VERSIONS_FILE = ARGV[0]
RECIPIENTS = ENV['RECIPIENTS'].split(',').map{ |r| r.strip }


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

def process_unknown_versions(versions) 
    puts versions

    url = URI(ENV['MAILGUN_URL'])
    req = Net::HTTP::Post.new(url.path)
    req.basic_auth 'api', ENV['MAILGUN_API_KEY']
    # req.use_ssl = true
    data = {
        'from' => "New releases<releases@#{ENV['MAILGUN_SERVER']}>",
        'subject' => "New releases found",
        'text' => "New releases:\n-------------\n\n#{versions.join("\n")}\n"
    }
    data = data.merge RECIPIENTS.map{ |r| ['to', r] }.to_h
    req.set_form_data(data)
    sock = Net::HTTP.new(url.host, url.port)
    sock.use_ssl = true
    response = sock.start {|http| http.request(req) }
    exit(12) unless response.kind_of? Net::HTTPSuccess
end


versions = get_ruby_versions_from_rss
versions.concat get_openjdk_versions
versions.concat get_python_versions
known_versions = read_known_versions
unknown_versions = match_versions(known_versions, versions)

process_unknown_versions(unknown_versions) unless unknown_versions.empty?

write_unknown_versions(known_versions, unknown_versions)
