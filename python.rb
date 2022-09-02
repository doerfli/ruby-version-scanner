require 'nokogiri'

def get_python_versions
    versions = []
    url = 'https://www.python.org/downloads/'
    URI.open(url) do |raw_html|
        document = Nokogiri::HTML(raw_html)
        releases = document.search('ol span.release-number a')
        releases.each{ |r| versions << r.text }
    end

    versions
end
