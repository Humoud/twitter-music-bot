FROM ruby:2.3.3

RUN mkdir -p /app/twitter-music-bot
COPY . /app/twitter-music-bot
WORKDIR /app/twitter-music-bot

RUN bundle install --system

RUN bundle exec rake db:drop
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate

CMD bundle exec nrb start
