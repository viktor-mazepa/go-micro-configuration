SHELL=cmd.exe
FRONT_END_BINARY=frontApp.exe
BROKER_BINARY=brokerApp
LOGGER_BINARY=loggerApp
MAILER_BINARY=mailerApp
AUTH_BINARY=authApp

## up: starts all containers in the background without forcing build
up: 
	@echo Starting Docker images...
	docker-compose up -d
	@echo Docker images started!

## up_build: stops docker-compose (if running), builds all projects and starts docker compose
up_build: build_broker build_auth build_logger build_mailer
	@echo Stopping docker images (if running...)
	docker-compose down
	@echo Building (when required) and starting docker images...
	docker-compose up --build -d
	@echo Docker images built and started!

## down: stop docker compose
down:
	@echo Stopping docker compose...
	docker-compose down
	@echo Done!

## build_broker: builds the broker binary as a linux executable
build_broker:
	@echo Building broker binary...
	chdir ..\go-micro-broker-service && set GOOS=linux&& set GOARCH=amd64&& set CGO_ENABLED=0 && go build -o ${BROKER_BINARY} ./cmd/api
	@echo Done!

## build_logger: builds the logger binary as a linux executable
build_logger:
	@echo Building logger binary...
	chdir ..\go-micro-logger-service && set GOOS=linux&& set GOARCH=amd64&& set CGO_ENABLED=0 && go build -o ${LOGGER_BINARY} ./cmd/api
	@echo Done!

## build_logger: builds the mailer binary as a linux executable
build_mailer:
	@echo Building mailer binary...
	chdir ..\go-micro-mail-service && set GOOS=linux&& set GOARCH=amd64&& set CGO_ENABLED=0 && go build -o ${MAILER_BINARY} ./cmd/api
	@echo Done!

## build_auth: builds the broker binary as a linux executable
build_auth:
	@echo Building auth binary...
	chdir ..\go-micro-auth-service && set GOOS=linux&& set GOARCH=amd64&& set CGO_ENABLED=0 && go build -o ${AUTH_BINARY} ./cmd/api
	@echo Done!

## build_front: builds the frone end binary
build_front:
	@echo Building front end binary...
	chdir ..\go-micro-frontend && set CGO_ENABLED=0&& set GOOS=windows&& go build -o ${FRONT_END_BINARY} ./cmd/web
	@echo Done!

## start: starts the front end
start: build_front
	@echo Starting front end
	chdir ..\go-micro-frontend && start /B ${FRONT_END_BINARY} &

## stop: stop the front end
stop:
	@echo Stopping front end...
	@taskkill /IM "${FRONT_END_BINARY}" /F
	@echo "Stopped front end!"
