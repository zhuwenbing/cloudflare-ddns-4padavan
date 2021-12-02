#!/bin/sh

# Zone ID:
ZoneID="cfe5f1a934234ed38103209f3d3bf363"

# DNS Record ID
# https://api.cloudflare.com/#dns-records-for-a-zone-list-dns-records
# curl -X GET "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records?type=A&name=$DNSRecordName&page=1&per_page=1&order=type&match=all" -H "X-Auth-Email: $AuthEmail" -H "X-Auth-Key: $AuthKey" -H "Content-Type: application/json" | sed -E 's/.*"id":"?([^,"]*
DNSRecordID="8889875987214b53a0662fd34cfbe984"

# Auth Email:
AuthEmail="master@example.com"

# Auth Key:
AuthKey="5f56669d8b7e088658d0d3de278b6937f8109"

# DNS Record Name:
DNSRecordName="demo.example.com"

# Get the current public IP
# DNS Record Content:
DNSRecordContent=$(curl -s http://ipv4.icanhazip.com)
# Exit if curl failed
if [ $? -ne 0 ]; then
  exit 1
fi

# Saved history pubic IP from last check
IP_FILE="/etc/storage/lastIP"
# Check file for previous IP address
if [ -f $IP_FILE ]; then
  KNOWN_IP=$(cat $IP_FILE)
else
  KNOWN_IP=
fi

# See if the IP has changed
if [ "$DNSRecordContent" == "$KNOWN_IP" ]; then
  echo "Public.IP.Check -- NO IP change"
else
  # Update DNS record in Cloudflare:
  # https://api.cloudflare.com/#dns-records-for-a-zone-update-dns-record
  SUCCESS=$(curl -X PUT "https://api.cloudflare.com/client/v4/zones/$ZoneID/dns_records/$DNSRecordID" -H "X-Auth-Email: $AuthEmail" -H "X-Auth-Key: $AuthKey" -H "Content-Type: application/json" --data '{"type":"A","name":"'$DNSRecordName'","content":"'$DNSRecordContent'","ttl":1,"proxied":false}' | sed -E 's/.*"success":"?([^,"]*)"?.*/\1/')
  # Exit if curl failed
  if [ $? -ne 0 ]; then
    exit 1
  fi
  # Exit if update failed
  if [ $SUCCESS == "false" ]; then
    exit 1
  fi
  echo $DNSRecordContent > $IP_FILE
  echo "Public.IP.Check -- Public IP changed to $DNSRecordContent"
fi

exit 0
