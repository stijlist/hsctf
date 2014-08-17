FROM litaio/ruby
EXPOSE 4567
#RUN adduser --disabled-password --home=/app --gecos "" app
RUN gem install bundler

ADD . /app
WORKDIR /app

RUN bundle install
CMD bundle exec ruby server.rb



