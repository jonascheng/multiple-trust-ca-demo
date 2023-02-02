.DEFAULT_GOAL := help

HOSTNAME?=`hostname`

GOOS?=linux
GOARCH?=amd64
CGO_ENABLED?=0

.PHONY: setup
setup: ## setup go modules
	cd client && go mod tidy

.PHONY: build
build: ## build Go client
	cd client && GOOS=${GOOS} GOARCH=${GOARCH} CGO_ENABLED=${CGO_ENABLED} go build main.go

.PHONY: run-mitmproxy
run-mitmproxy: ## run mitmproxy, and listen on port 8080
	docker run -it --rm \
		-p 8080:8080 \
		-v `pwd`/${HOSTNAME}:/home/mitmproxy/.mitmproxy \
		mitmproxy/mitmproxy

.PHONY: run-go-client
run-go-client: setup ## runs Go client
	cd client && go run main.go

.PHONY: run-docker-go-client
run-docker-go-client: ## runs Go client in docker
	# copy mitmproxy ca to folder share-ca with postfix .crt
	mkdir -p share-ca
	cp mitmproxy1/mitmproxy-ca-cert.pem share-ca/mitmproxy1-ca-cert.crt
	cp mitmproxy2/mitmproxy-ca-cert.pem share-ca/mitmproxy2-ca-cert.crt
	docker build -t local/go-client -f client/Dockerfile .
	docker run -it -v `pwd`/share-ca:/usr/local/share/ca-certificates local/go-client:latest

.PHONY: help
help: ## prints this help message
	@echo "Usage: \n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
