### converting certbot's private key from JSON to PEM; how to find them,
### on OSX/Linux: sudo find /etc/letsencrypt/accounts/ -name private_key.json
---
```bash
./certbot-jsonkey-convert.py private_key.json > private-key.asn1
openssl asn1parse -genconf private-key.asn1 -noout -out private-key.der
openssl rsa -inform DER -in private-key.der -outform PEM -out cert-private-key.pem
```
---
### to have tarsnap backup working, make own account at https://www.tarsnap.com/
### then save (all) your tarsnap private server keys in this /files folder as:
### {put-server's-FQDN-here}-tarsnap.key
