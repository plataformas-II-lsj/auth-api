FROM golang:1.18.2-alpine3.16 AS builder

WORKDIR /builder

COPY . .
RUN go mod init auth-api
RUN go mod tidy
RUN go build

FROM alpine:3.16

WORKDIR /app
COPY --from=builder /builder/auth-api .
ENV JWT_SECRET=PRFT 
ENV AUTH_API_PORT=8000
ENV USERS_API_ADDRESS=http://127.0.0.1:8083
ENV ZIPKIN_URL=http://127.0.0.1:9411/api/v2/spans

EXPOSE 8000

ENTRYPOINT ["/app/auth-api"]
