package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
	log.Print("starting server...")
	http.HandleFunc("/", handler)

	port := "8080"

	// start Http Server
	log.Printf("listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func handler(w http.ResponseWriter, r *http.Request) {
	name := r.FormValue("name")
	if name == "" {
		name = "World"
	}
	fmt.Fprintf(w, "Hello %s!\n", name)
}
