FROM ruby:2.6.5

RUN apt-get update -qq && \
    apt-get install -y build-essential \ 
                       libpq-dev \        
                       npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | sh -
RUN apt-get -y install nodejs

RUN mkdir /share_bike

ENV APP_ROOT /share_bike
WORKDIR $APP_ROOT

WORKDIR /$APP_ROOT/tmp
ADD ./Gemfile $APP_ROOT/Gemfile
ADD ./Gemfile.lock $APP_ROOT/Gemfile.lock
RUN bundle install

WORKDIR $APP_ROOT
ADD . $APP_ROOT

EXPOSE  3000
