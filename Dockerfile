FROM ruby:3-slim
ADD versions.rb .
CMD ruby versions.rb
