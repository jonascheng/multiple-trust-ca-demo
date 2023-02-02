Support multiple custom CA

# How to test?

1. `vagrant up`

2. ssh to mitmproxy1 or mitmproxy2 server

    ```console
    vagrant ssh mitmproxy1
    ```

3. start up mitmproxy in 2 servers

    ```console
    cd /vagrant
    make run-mitmproxy
    ```

    These two servers will also generate its own CA in `./mitmproxy1/mitmproxy-ca-cert.pem` and `./mitmproxy2/mitmproxy-ca-cert.pem`

4. open up another terminal and ssh to client server as step.2

5. test Go client to load multiple custom CAs

    ```console
    cd /vagrant
    make run-go-client
    ```

6. test Go client to mount multiple custom CAs, and re-generate system managed /etc/ssl/certs/ca-certificates.crt

    ```console
    cd /vagrant
    make run-docker-go-client
    ```

    * pitfall: update-ca-certificates can only recognize `.crt` instead of `.pem`

# References

* [如何使用 OpenSSL 簽發中介 CA](https://blog.davy.tw/posts/use-openssl-to-sign-intermediate-ca/)