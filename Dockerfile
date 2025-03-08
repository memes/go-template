# TODO: @memes
#  - search for APP and update as needed
#  - expose ports in scratch container
#  - add additional labels, if needed
#  - add CMD as needed
FROM alpine:3.21.3 as ca
RUN apk --no-cache add ca-certificates-bundle=20241121-r1

FROM scratch
COPY --from=ca /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
EXPOSE 8080
COPY APP /APP
ENTRYPOINT ["/APP"]
