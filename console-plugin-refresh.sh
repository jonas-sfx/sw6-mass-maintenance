#!/bin/bash

## filename     console-plugin-refresh.sh
## description: run "console plugin:refresh" on the sw console of each shop
##              refreshing the information
##              about your currently installed shopware plugins
## author:      jonas@sfxonline.de
## ========================================================================

for row in $(jq -r '.[] | @base64' data/shops.json); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  ssh $(_jq '.host') "$(_jq '.console') plugin:refresh"
done
