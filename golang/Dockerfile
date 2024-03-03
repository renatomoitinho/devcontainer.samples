FROM golang:1.22.0-alpine3.19 as builder

LABEL maintainer="Renato Moitinho"

RUN apk add --update --no-cache make

WORKDIR /app

COPY . .

RUN make build

FROM scratch

COPY --from=builder /app/dist/hello /hello

ENTRYPOINT ["./hello"]
