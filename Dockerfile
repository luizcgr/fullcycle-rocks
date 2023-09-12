FROM alpine:3.18.3 AS goalpine

WORKDIR /downloads
RUN apk update && apk --no-cache add wget
RUN wget https://go.dev/dl/go1.21.1.linux-386.tar.gz
RUN tar -C /usr/local -xzf go1.21.1.linux-386.tar.gz
RUN ln -s /usr/local/go/bin/go /usr/local/bin

WORKDIR /app
# RUN go mod init luizcgr/fullcycle
COPY go.mod ./
COPY fullcycle.go ./

RUN GOOS=linux go build ./fullcycle.go

CMD ["go", "run", "."]

FROM scratch

WORKDIR /app
COPY --from=goalpine /app/fullcycle .
CMD ["/app/fullcycle"]
