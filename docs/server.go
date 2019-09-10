package main

import (
	"fmt"
	"log"
	"net/http"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func main() {

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		path := r.URL.Path[1:]
		fmt.Printf("Getting file '%s'\n", path)
		if strings.HasSuffix(path, ".js") ||
			strings.HasSuffix(path, ".html") ||
			strings.HasSuffix(path, ".css") ||
			strings.HasSuffix(path, ".wasm") ||
			strings.HasSuffix(path, ".data") ||
			strings.HasSuffix(path, ".lua") {
			filename := path
			fmt.Printf("retrieving %s\n", filename)
			http.ServeFile(w, r, filename)
		} else if path == "" {
			http.ServeFile(w, r, "index.html")
		} else {
			fmt.Printf("Not found!!")
			http.ServeFile(w, r, "index.html")
		}
	})

	// http.HandleFunc("/weather/herminia1.html", func(w http.ResponseWriter, r *http.Request) {
	// 	http.ServeFile(w, r, "herminia1.html")
	// })

	// http.HandleFunc("/weather/herminia2.html", func(w http.ResponseWriter, r *http.Request) {
	// 	http.ServeFile(w, r, "herminia2.html")
	// })

	log.Fatal(http.ListenAndServe(":8000", nil))

}
