# Build Stage
FROM golang:1.23.2-alpine AS build

# Set necessary environment variables for Go cross-compilation
ENV CGO_ENABLED=0
ENV GOOS=linux

# Update CA Certs
RUN apk --update --no-cache add ca-certificates

# Set the working directory inside the container
WORKDIR /app

# Copy the source code
COPY . .

# Download Go modules
RUN go mod tidy

# Build the Go application
RUN go build -o wsrif main.go

# Final Stage
FROM scratch AS final

# Copy the built binary from the build stage
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build /app/wsrif /wsrif

# Command to run the application
CMD ["/wsrif"]