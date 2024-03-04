package main

import (
	"hello/pkg/server"
	"log"
)

func main() {
	s := &server.Server{Addr: ":8080"}
	log.Fatal(s.Start())
}
