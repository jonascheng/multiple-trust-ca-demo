package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"time"
)

func req(webUrl, proxyUrl string) error {
	// load trusted root CA
	rootCAs, _ := x509.SystemCertPool()
	if rootCAs == nil {
		log.Println("fail to load from system cert pool")
		rootCAs = x509.NewCertPool()
	}

	for i := 1; i <= 2; i++ {
		fileName := fmt.Sprintf("../mitmproxy%d/mitmproxy-ca-cert.pem", i)
		serverCert, err := ioutil.ReadFile(fileName)
		if err != nil {
			log.Printf("skip reading server ca %s, err=%v", fileName, err)
			continue
		}
		rootCAs.AppendCertsFromPEM(serverCert)
	}

	config := tls.Config{
		InsecureSkipVerify: false,
		RootCAs:            rootCAs,
	}

	proxy, err := url.Parse(proxyUrl)
	if err != nil {
		log.Printf("fail to parse proxy %s, err=%v", proxyUrl, err)
		return err
	}
	tr := &http.Transport{
		Proxy:           http.ProxyURL(proxy),
		TLSClientConfig: &config,
	}

	client := &http.Client{
		Transport: tr,
		Timeout:   time.Second * 5,
	}

	resp, err := client.Get(webUrl)
	if err != nil {
		log.Printf("fail to get from %s via %s, err=%v", webUrl, proxyUrl, err)
		return err
	}

	defer resp.Body.Close()
	body, _ := ioutil.ReadAll(resp.Body)
	// log.Println(string(body))
	log.Printf("ok to request %s via %s, return lengh %d", webUrl, proxyUrl, len(body))

	return nil
}

func main() {
	req("https://www.google.com", "//172.31.1.20:8080")
	req("https://www.google.com", "//172.31.1.30:8080")
}
