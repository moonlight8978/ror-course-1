# Simple CLoneVOZ app for framgia's training course

* For research purpose

### Environment
```bash
$ ruby -v
# ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]
$ rails -v
# Rails 5.2.1
```

### Setup (with docker)
* Build and install npm packages
```bash
$ docker-compose build
$ docker-compose run --rm server npm i
```
* Create credentials
```bash
$ docker-compose run --rm server bash
# From container run, DATABASE_HOST must be 'db'
$ EDITOR=vim rails credentials:edit
```
* Run the stack
```bash
$ docker-compose up -d
```

### Setup (without docker)
* Install dependencies:
```bash
$ sudo apt-get update && sudo apt-get install imagemagick
$ bundle install
$ npm i
```
* Create env variables, following by `config/credentials.yml.sample`
```bash
$ EDITOR=gedit rails credentials:edit  # or EDITOR=vim
$ rails credentials:show  # to show credentials
```
* Create database
```bash
$ rake db:reset db:seed
```
* Run server
```bash
$ rails s
```
