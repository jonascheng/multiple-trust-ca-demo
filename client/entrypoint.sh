#!/bin/bash

# re-generate system managed /etc/ssl/certs/ca-certificates.crt
/usr/sbin/update-ca-certificates

/app/client/main

# press any key to continue
read -n 1 -p "press any key to continue"
