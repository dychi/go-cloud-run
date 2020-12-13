# builder base image
FROM golang:1.15-buster AS builder
# set working directory
WORKDIR /app
COPY go.* ./
RUN go mod download

COPY . ./
# Build the binary.
RUN go build -mod=readonly -v -o server

# Use the official Debian slim image for a lean production container.
FROM debian:buster-slim
RUN set -x && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Copy the binary to the production image from the builder stage.
COPY --from=builder /app/server /app/server

CMD ["/app/server"]