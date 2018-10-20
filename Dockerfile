FROM ruby:latest as dev

ARG APP_PATH
ARG PORT

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y \
  build-essential \
  libpq-dev \
  imagemagick \
  nodejs \
  vim
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install --no-install-recommends yarn

RUN mkdir $APP_PATH
WORKDIR $APP_PATH

COPY package.json yarn.lock ./
RUN yarn install

COPY Gemfile* ./
RUN bundle install

COPY . .

EXPOSE $PORT
