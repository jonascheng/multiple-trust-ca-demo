FROM golang:1.19.3-alpine AS builder
RUN apk add -U --no-cache upx make bash

WORKDIR /app
COPY . .
RUN make build
RUN upx /app/client/main

FROM debian:bullseye-slim
RUN apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends ca-certificates

WORKDIR /app
COPY --from=builder /app/client/entrypoint.sh /app/client/entrypoint.sh
COPY --from=builder /app/client/main /app/client/main

ENTRYPOINT ["/app/client/entrypoint.sh"]
