FROM ruby:latest

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV RAILS_ENV production
ENV RAILS_LOG_TO_STDOUT true
ENV DATABASE_URL postgres

WORKDIR /var/www/million/

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install
RUN bundle exec rails db:setup

COPY . /var/www/million/

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
