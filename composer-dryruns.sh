#!/bin/bash

## filename     composer-dryruns.sh
## description: run "composer update --dry-run" on each shop
##              to check for available updates on your composer packages
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
  ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update --dry-run"
done