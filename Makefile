.DEFAULT_GOAL := help

HOSTNAME?=`hostname`

.PHONY: setup
setup: ## setup go modules
	cd client && go mod tidy

.PHONY: run-mitmproxy
run-mitmproxy: ## run mitmproxy, and listen on port 8080
	docker run -it --rm \
		-p 8080:8080 \
		-v `pwd`/${HOSTNAME}:/home/mitmproxy/.mitmproxy \
		mitmproxy/mitmproxy

.PHONY: run-go-client
run-go-client: setup ## runs syslog Go client
	cd client && go run main.go

.PHONY: help
help: ## prints this help message
	@echo "Usage: \n"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
