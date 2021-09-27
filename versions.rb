require 'rss'
require 'open-uri'

RELEASE_TITLE = /Ruby (\d+\.\d+\.\d+) Released/

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
    return [] unless File.exists?('knownversions.txt')
    File.readlines('knownversions.txt').map { |v| v.strip }
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
        File.open('knownversions.txt', 'w') { |file| 
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
end


versions = get_versions_from_rss
known_versions = read_known_versions
unknown_versions = match_versions(known_versions, versions)

unknown_versions.each { |v| 
    process_unknown_version(v)
}

write_unknown_versions(known_versions, unknown_versions)
