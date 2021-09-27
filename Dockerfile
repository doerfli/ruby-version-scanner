FROM ruby:3-slim
VOLUME /data
ADD versions.rb .
CMD ruby versions.rb /data/knownversions.txt
