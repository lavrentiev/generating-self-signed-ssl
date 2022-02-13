# Generating self-signed SSL certificates for local development
```shell
./ssl.sh [ ca_certificate_name: default ] [ domain_name: example.my ]
```

```text
Generating RSA private key, 2048 bit long modulus
................................................................+++
...+++
e is 65537 (0x10001)
Generating a 2048 bit RSA private key
.............................................................................................+++
..................................................................+++
writing new private key to '.build/example.my.key'
-----
Signature ok
subject=/C=RU/ST=Moscow/L=Moscow/O=Personal CA Certifications/OU=Personal CA Certifications/emailAddress=stub@personal.localhost/CN=Personal CA Certifications
Getting CA Private Key
CA Certificate (...key): .build/default_ca.key
CA Certificate (...pem): .build/default_ca.pem
CA Certificate (...subject): /C=RU/ST=Moscow/L=Moscow/O=Personal CA Certifications/OU=Personal CA Certifications/emailAddress=stub@personal.localhost/CN=Personal CA Certifications
Certificate (...key): .build/example.my.key
Certificate (...crt): .build/example.my.crt
Certificate (...csr): .build/example.my.csr
Certificate (...ext): .build/example.my.ext
Certificate (...subject): /C=RU/ST=Moscow/L=Moscow/O=Personal CA Certifications/OU=Personal CA Certifications/emailAddress=stub@personal.localhost/CN=Personal CA Certifications
```