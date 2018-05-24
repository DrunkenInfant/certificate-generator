# Certificate generator

Generates and maintains a self-signed X509 certificate.

Each time the container is started it will make sure a valid
certificate with enough expiry margin is generated.

## Usage

```
$ docker run -d \
  --name crt-gen \
  -v /var/ssl/my.service.com:/var/ssl
  -e CERT_PATH=/var/ssl
  -e COMMON_NAME=my.service.com \
  -e VALID_DAYS=10 \
  pntregistry.azurecr.io/certificate-generator
```

Available environment variables:

 * `CERT_PATH` Path where the certificate and private key will be
   saved, default `/var/ssl`.
 * `COMMON_NAME` The CN of the generated certificate, this will be
   matched with domain name if used for HTTPS termination, default:
   `pnt_service`.
 * `SUBJECT` Additional certificate subject excluding the common
   name. The final subject of the certificate will be
   `$SUBJECT/CN=$COMMON_NAME`. Default `/C=SE/O=Plug and Trade`
 * `VALID_DAYS` The number of days the certificate should be valid
   for, default `365`.
 * `VALID_MARGIN_SEC` The minimum number of remaining time the
   certificate must be valid for. The certificate will be replaced if
   it expires within this time. The value is specified in seconds.
   Default `86400` (1 day).
