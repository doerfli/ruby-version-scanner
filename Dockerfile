FROM ruby:3-slim
VOLUME /data
ADD *.rb .
ENTRYPOINT ruby versions.rb /data/knownversions.txt
