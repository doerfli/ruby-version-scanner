FROM ruby:3-slim
VOLUME /data
ADD *.rb /
RUN gem install rss nokogiri
ENTRYPOINT ruby versions.rb /data/knownversions.txt
