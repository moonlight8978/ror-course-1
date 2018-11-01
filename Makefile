.PHONY: help build start stop generate db console run

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
	@echo "    generate <args>: rails g ..."
	@echo "    db:              Reset database"
	@echo "    console:         Run server rails console"
	@echo "    run <args>:      Run command"

build:
	@docker-compose build

start:
	@docker-compose up -d

stop:
	@docker-compose down

generate:
	@docker-compose run -u $(id -u):$(id -g) --rm ${SERVER} rails g $(filter-out $@,$(MAKECMDGOALS))

db:
	@docker-compose run --rm ${SERVER} db:reset

console:
	@docker-compose run --rm ${SERVER} rails c

run:
	@docker-compose run --rm ${SERVER} $(filter-out $@,$(MAKECMDGOALS))
