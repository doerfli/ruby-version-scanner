require 'nokogiri'

def get_meteor_versions
    versions = []
    url = 'https://docs.meteor.com/changelog.html'
    URI.open(url) do |raw_html|
        document = Nokogiri::HTML(raw_html)
        releases = document.search('h2')
        releases.each{ |r| versions << r.text[0,r.text.index(',')] }
    end

    versions.map{ |e| "Meteor #{e}"}
end
