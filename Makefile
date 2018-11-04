.PHONY: help build start stop db-migrate db-reset generate console bash run spec fix lint ci

SERVER = server

.DEFAULT_GOAL := help

help:
	@echo "Usage:"
	@echo "  $$ make [command]"
	@echo ""
	@echo "  Commands:"
	@echo "    help (default):  Show usage"
	@echo "    build:           Build the app stack"
	@echo "    start:           Run the app stack"
	@echo "    stop:            Stop the app stack"
	@echo "    credentials:     Edit the credentials"
	@echo "    db-migrate:      Migrate database"
	@echo "    db-reset:        Reset database"
	@echo "    generate <args>: rails g ..."
	@echo "    console:         Run server rails console"
	@echo "    bash:            bin/bash inside container"
	@echo "    run <args>:      Run command"
	@echo "    spec:            Run test"
	@echo "    fix:             Fix rubocop conventions"
	@echo "    lint:            Linting with stylelint and eslint"
	@echo "    ci:              Run the check like CI"

build:
	@docker-compose build
	@docker-compose run --rm ${SERVER} yarn
	@docker-compose down

start:
	@docker-compose up -d

stop:
	@docker-compose down

credentials:
	@docker-compose run -e EDITOR=vim --rm ${SERVER} rails credentials:edit

db-migrate:
	@docker-compose run --rm ${SERVER} rake db:migrate

db-reset:
	@docker-compose down
	@docker-compose run --rm ${SERVER} rake db:reset data:score data:counter
	@docker-compose up -d

generate:
	@docker-compose run -u $$(id -u):$$(id -g) --rm ${SERVER} rails g $(filter-out $@,$(MAKECMDGOALS))

console:
	@docker-compose run --rm ${SERVER} rails c

bash:
	@docker-compose run --rm ${SERVER} bash

run:
	@docker-compose run --rm ${SERVER} $(filter-out $@,$(MAKECMDGOALS))

spec:
	@docker-compose run --rm ${SERVER} rake spec

fix:
	@docker-compose run --rm ${SERVER} rubocop -a

lint:
	docker-compose run --rm ${SERVER} yarn eslint
	docker-compose run --rm ${SERVER} yarn stylelint

ci: lint fix spec
