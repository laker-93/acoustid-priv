FROM golang:1.19 as builder
WORKDIR /go/src/github.com/acoustid/priv
COPY ./ ./
RUN go env -w GO111MODULE=auto
RUN go build github.com/acoustid/priv/cmd/acoustid-priv-api

FROM alpine
RUN apk --no-cache add curl ca-certificates
RUN apk add gcompat
EXPOSE 3382
HEALTHCHECK CMD curl -f http://localhost:3382/_health || exit 1
COPY --from=builder /go/src/github.com/acoustid/priv/acoustid-priv-api /usr/local/bin/
CMD ["acoustid-priv-api"]
