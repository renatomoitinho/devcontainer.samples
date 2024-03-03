package server

import (
	"testing"
)

func TestMyServer(t *testing.T) {
	result := &Server{Addr: ":8080"}
	if result.Addr != ":8080" {
		t.Errorf("Expected %s, but got %s", ":8080", result.Addr)
	}
}
