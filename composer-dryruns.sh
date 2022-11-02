#!/bin/bash

## filename     composer-dryruns.sh
## description: run "composer update --dry-run" on each shop
##              to check for available updates on your composer packages
## author:      jonas@sfxonline.de
## =======================================================================

for row in $(cat data/shops.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
  echo
  echo '-----------------'
  echo $(_jq '.name')
  echo '-----------------'
  ssh $(_jq '.host') "cd  $(_jq '.webroot') && $(_jq '.composer') update --dry-run"
done