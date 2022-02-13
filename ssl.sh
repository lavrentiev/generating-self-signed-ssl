#!/bin/bash

BUILD_SSL_PATH=".build"

CERTIFICATE_CA_NAME="default"
if [[ $1 ]]; then CERTIFICATE_CA_NAME="${1}"; fi

CERTIFICATE_CA_PREFIX="ca"
CERTIFICATE_CA_KEY="${BUILD_SSL_PATH}/${CERTIFICATE_CA_NAME}_${CERTIFICATE_CA_PREFIX}.key"
CERTIFICATE_CA_PEM="${BUILD_SSL_PATH}/${CERTIFICATE_CA_NAME}_${CERTIFICATE_CA_PREFIX}.pem"
CERTIFICATE_CA_SUBJ="/C=RU/ST=Moscow/L=Moscow/O=Personal CA Certifications/OU=Personal CA Certifications/emailAddress=stub@personal.localhost/CN=Personal CA Certifications"

CERTIFICATE_NAME="example.my"
if [[ $2 ]]; then CERTIFICATE_NAME="${2}"; fi

CERTIFICATE_EXT_FILE="${BUILD_SSL_PATH}/${CERTIFICATE_NAME}.ext"
CERTIFICATE_KEY="${BUILD_SSL_PATH}/${CERTIFICATE_NAME}.key"
CERTIFICATE_CSR="${BUILD_SSL_PATH}/${CERTIFICATE_NAME}.csr"
CERTIFICATE_CRT="${BUILD_SSL_PATH}/${CERTIFICATE_NAME}.crt"
CERTIFICATE_SUBJ="/C=RU/ST=Moscow/L=Moscow/O=Personal CA Certifications/OU=Personal CA Certifications/emailAddress=stub@personal.localhost/CN=Personal CA Certifications"

if [[ ! -e $BUILD_SSL_PATH ]]; then
  mkdir $BUILD_SSL_PATH
fi

if [[ ! -f $CERTIFICATE_CA_KEY ]]; then
  openssl genrsa -passout pass:"password" -des3 -out "${CERTIFICATE_CA_KEY}" 2048
  openssl req -passin pass:"password" -x509 -new -nodes -key "${CERTIFICATE_CA_KEY}" \
    -sha256 -days 1024 -out "${CERTIFICATE_CA_PEM}" \
    -subj "${CERTIFICATE_CA_SUBJ}"
fi

cat << EOF > "${CERTIFICATE_EXT_FILE}"
authorityKeyIdentifier = keyid, issuer
basicConstraints = CA: FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = $CERTIFICATE_NAME
DNS.2 = *.$CERTIFICATE_NAME
EOF

openssl req -passin pass:"" -new -nodes -out "${CERTIFICATE_CSR}" -newkey rsa:2048 -keyout "${CERTIFICATE_KEY}" \
  -subj "${CERTIFICATE_SUBJ}"

openssl x509 -req -passin pass:"password" -in "${CERTIFICATE_CSR}" -CA "${CERTIFICATE_CA_PEM}" \
  -CAkey "${CERTIFICATE_CA_KEY}" -CAcreateserial -out "${CERTIFICATE_CRT}" -days 500 -sha256 \
  -extfile "${CERTIFICATE_EXT_FILE}"

echo "CA Certificate (...key): ${CERTIFICATE_CA_KEY}"
echo "CA Certificate (...pem): ${CERTIFICATE_CA_PEM}"
echo "CA Certificate (...subject): ${CERTIFICATE_CA_SUBJ}"
echo "Certificate (...key): ${CERTIFICATE_KEY}"
echo "Certificate (...crt): ${CERTIFICATE_CRT}"
echo "Certificate (...csr): ${CERTIFICATE_CSR}"
echo "Certificate (...ext): ${CERTIFICATE_EXT_FILE}"
echo "Certificate (...subject): ${CERTIFICATE_SUBJ}"
