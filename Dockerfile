# Build stage
FROM golang:alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Final stage
FROM alpine:latest

WORKDIR /root/

# Copy the binary from builder stage
COPY --from=builder /app/main .

# Expose port 8080 to the outside
EXPOSE 8080

# Run the executable
CMD ["./main"]