FROM ruby:3.2.3
RUN apt-get update
RUN apt-get install -y build-essential
WORKDIR /api
COPY Gemfile /api/
RUN bundle install
EXPOSE 3017
CMD rm -f /api/tmp/pids/server.pid && bundle exec rails s -p 3017 -b '0.0.0.0'
