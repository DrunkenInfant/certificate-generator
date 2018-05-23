#!/bin/sh

CRT_FILE="$CERT_PATH/$COMMON_NAME.crt"
KEY_FILE="$CERT_PATH/$COMMON_NAME.key"

generate_new() {
  openssl req \
    -new \
    -newkey rsa:2048 \
    -sha256 \
    -days $VALID_DAYS \
    -subj "$SUBJECT/CN=$COMMON_NAME" \
    -nodes \
    -x509 \
    -keyout "$KEY_FILE" \
    -out "$CRT_FILE"
}

mkdir -p "$CERT_PATH"

if [ ! -f "$CRT_FILE" ]; then
  echo "Generating certificate"
  generate_new
elif ! openssl x509 -checkend $VALID_MARGIN_SEC -noout -in "$CRT_FILE"; then
  echo "Generating replacement certificate"
  rm -f "$CRT_FILE" "$KEY_FILE"
  generate_new
fi


FING_HEX=$(openssl x509 -noout -fingerprint -sha256 -inform pem -in "$CRT_FILE" | cut -d= -f2)
FING_B64=$(openssl x509 -in "$CRT_FILE" -outform der | openssl dgst -sha256 -binary | openssl base64 -A)

echo "Expires at: $(openssl x509 -enddate -noout -in "$CRT_FILE" | cut -d= -f2)"
echo "Fingerprint hex: $FING_HEX"
echo "Fingerprint base64: $FING_B64"
cat "$CRT_FILE"

exec $@
