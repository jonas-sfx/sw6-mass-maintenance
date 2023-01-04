#!/bin/bash

## filename     console-abouts.sh
## description: run "console about" on the shopware console of each shop
## author:      jonas@sfxonline.de
## =======================================================================

for row in $(jq -r '.[] | @base64' data/shops.json); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  ssh "$(_jq '.host')" "$(_jq '.console') about"
done