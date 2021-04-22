ARG GOLANG_VERSION=1.16
ARG VERSION=unversioned

FROM golang:${GOLANG_VERSION}-alpine as builder

WORKDIR /src
COPY ./go.mod ./go.mod
RUN go mod download
COPY . .
WORKDIR /src
RUN CGO_ENABLED=0 go build -ldflags "-X github.com/dropbox/dbxcli/main.version=${VERSION}" -o dbxcli .


FROM scratch
LABEL maintainer="Will Fantom <willf@ntom.dev>"

WORKDIR /dbxcli
COPY --from=builder /src/dbxcli .

ENTRYPOINT [ "./dbxcli" ]
