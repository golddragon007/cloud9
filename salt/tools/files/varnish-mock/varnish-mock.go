package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"
)

// formatRequest generates ascii representation of a request
func formatRequest(r *http.Request) string {
	// Create return string
	var request []string

	// Add the request string
	url := fmt.Sprintf("%v %v %v", r.Method, r.URL, r.Proto)
	request = append(request, url)

	// Add the host
	request = append(request, fmt.Sprintf("Host: %v", r.Host))

	// Loop through headers
	for name, headers := range r.Header {
		name = strings.ToLower(name)
		for _, h := range headers {
			request = append(request, fmt.Sprintf("%v: %v", name, h))
		}
	}

	// If this is a POST, add post data
	if r.Method == "POST" {
		r.ParseForm()
		request = append(request, "\n")
		request = append(request, r.Form.Encode())
	}

	// Return the request as a string
	return strings.Join(request, "\n")
}

func printHeader(w http.ResponseWriter, r *http.Request) {

	date := time.Now().Format("2006-01-02 15:04:05")
	separator := strings.Repeat("-", 20)
	headerFormatted := formatRequest(r)
	message := fmt.Sprintf("%s %s %s\n%s", separator, date, separator, headerFormatted)

	if filePath != "none" {
		writeToFile(filePath, message+"\n")
	}

	fmt.Println(message)
	w.Write([]byte(message + "\n"))
}

func writeToFile(fp string, m string) bool {
	// If the file doesn't exist, create it, or append to the file
	f, err := os.OpenFile(fp, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatal(err)
	}
	if _, err := f.Write([]byte(m)); err != nil {
		log.Fatal(err)
	}
	if err := f.Close(); err != nil {
		log.Fatal(err)
	}

	return true
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

var port int
var filePath string

// init falgs.
func init() {
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Create a varnish mock server and print header of received http query.\nUsage of %s:\n ", os.Args[0])
		flag.PrintDefaults()
	}

	flag.IntVar(&port, "port", 6081, "Port of varnish mock server")
	flag.StringVar(&filePath, "filePath", "none", "Filepath to save output in file")
	flag.Parse()
}

func main() {
	// registers the handler function for root path
	http.HandleFunc("/", printHeader)

	log.Printf("Server started at port %v", port)
	// Start webServer
	err := http.ListenAndServe(":"+strconv.Itoa(port), nil)
	check(err)

}
