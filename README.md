# Simple CLoneVOZ app for framgia's training course

[![Build Status](https://travis-ci.com/moonlight8978/ror-course-1.svg?branch=master)](https://travis-ci.com/moonlight8978/ror-course-1)
[![Repository](https://img.shields.io/badge/repo-ror--course--1-brightgreen.svg)](https://github.com/moonlight8978/ror-course-1)

- For research purpose

- Production: [link](http://ec2-18-136-194-38.ap-southeast-1.compute.amazonaws.com/)

### Development environment

```bash
$ ruby -v
# ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux]
$ rails -v
# Rails 5.2.1
$ docker -v
# Docker version 18.06.1-ce, build e68fc7a
$ docker-compose -v
# docker-compose version 1.22.0, build f46880fe
```

### before(:all)

```bash
$ cp Makefile.development Makefile
```

### Help

```bash
$ make help
```

### Setup with Docker (Recommened)

- Pick your favorite ports by editing the `.env` file

- Build and install npm packages

```bash
$ make build
```

- Create credentials following by `config/credentials.sample.yml

```bash
$ make credentials
# Note that DATABASE_HOST must be 'db'
```

- Create db

```bash
$ make db-reset
# You can browse the db using pgAdmin4 by visit http://localhost:9696
```

- Run the stack

```bash
$ make start
# Visit http://localhost:6969
# And stop the stack
$ make stop
```

### Setup without Docker

- Install dependencies:

```bash
$ sudo apt-get update && sudo apt-get install imagemagick
$ bundle
$ yarn
```

- Create env variables, following by `config/credentials.sample.yml`

```bash
$ EDITOR=gedit rails credentials:edit  # or EDITOR=vim
$ rails credentials:show  # to show credentials
```

- Create database

```bash
$ rake db:reset db:seed data:score data:counter
```

- Run server

```bash
$ rails s
```
