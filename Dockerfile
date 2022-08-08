FROM ruby:2.7.6

ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV RAILS_ROOT /opt/app

RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
COPY . .

RUN apt-get update && apt-get install -y default-libmysqlclient-dev netcat nodejs
RUN gem install bundler --no-document
RUN bundle config set without 'development test'
RUN bundle check || bundle install

# Precompile assets for a production environment.
# This is done to include assets in production images on Dockerhub.
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Startup
CMD ["bin/docker-start"]
