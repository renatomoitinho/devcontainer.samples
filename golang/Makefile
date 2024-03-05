.PHONY: test play build install docker

test: # test
	CGO_ENABLED=0 go test ./...

play: # play with go
	go run cmd/hello/main.go

pre-build: # before build
	go mod tidy
	go mod download

build: pre-build # build binary
	GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ./dist/hello ./cmd/hello

install: pre-build # install binary
	GOBIN=/go/bin/ GO111MODULE=on CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install ./cmd/hello

docker: # docker build
	docker build -t renatomoitinho/basicgo:latest -f Dockerfile .
