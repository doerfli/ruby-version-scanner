require 'rss'
require 'open-uri'
require 'net/http'
require 'uri'

def get_ruby_versions_from_rss
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
    versions.map{ |e| "Ruby #{e}"}
end
