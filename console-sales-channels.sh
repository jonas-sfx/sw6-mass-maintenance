#!/bin/bash

## filename     console-sales-channels.sh
## description: run "console sales-channel:list" on the sw console of each shop
##              listing your currently available sales-channels
## author:      jonas@sfxonline.de
## ============================================================================

for row in $(jq -r '.[] | @base64' data/shops.json); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  ssh "$(_jq '.host')" "$(_jq '.console') sales-channel:list"
done
