FROM ruby:3-slim
VOLUME /data
ADD versions.rb .
ENTRYPOINT ruby versions.rb /data/knownversions.txt
