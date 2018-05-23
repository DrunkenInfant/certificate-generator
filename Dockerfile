FROM alpine:edge

RUN apk add --no-cache openssl
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

ENV CERT_PATH /var/ssl
ENV COMMON_NAME "pnt_service"
ENV SUBJECT "/C=SE/O=Plug and Trade"
ENV VALID_DAYS 365
ENV VALID_MARGIN_SEC 86400

ENTRYPOINT ["entrypoint.sh"]
CMD ["/bin/true"]
