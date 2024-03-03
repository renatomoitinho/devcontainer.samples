.PHONY: test play build install docker

test:
	CGO_ENABLED=0 go test ./...

play:
	go run cmd/main.go

pre-build:
	go mod tidy
	go mod download

build: pre-build
	GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./dist/hello ./cmd/hello

install: pre-build
	GOBIN=/go/bin/ GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install ./cmd/hello

docker:
	docker build -t renatomoitinho/basicgo:latest -f Dockerfile .
