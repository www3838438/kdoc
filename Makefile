
# Versions
ELASTICSEARCH_VERSION := 5.4.1
ACTIVEMQ_VERSION := 5.13.3
MARIADB_VERSION := 10.0

.PHONY: all
all: fetch build start

.PHONY: fetch
fetch:
	@echo "Fetching images ..."
	@docker pull docker.elastic.co/elasticsearch/elasticsearch:$(ELASTICSEARCH_VERSION)
	@docker pull rmohr/activemq:$(ACTIVEMQ_VERSION)
	@docker pull mariadb:$(MARIADB_VERSION)
	@echo "Fetch finished"

.PHONY: build
build:
	@echo "Building images ..."
	@docker build -t dmalczyk/kstack-nifi ./kstack-nifi
	@docker build -t dmalczyk/kstack-hadoophost ./kstack-hadoophost
	@docker build -t dmalczyk/kstack-kylo ./kstack-kylo
	@echo "Build finished"

.PHONY: start
start:
	@echo "Starting Kylo stack ..."
	@docker stack deploy -c docker-compose.yml kstack
	@echo "Started stack"

.PHONY: start-dev
start-dev:
	@echo "Starting Kylo stack ..."
	@docker stack deploy -c docker-compose-dev.yml kstack
	@echo "Started stack"

.PHONY: stop
stop:
	@echo "Stoping stack ..."
	@docker stack rm kstack
	@echo "Stoped stack"