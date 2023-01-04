#!/bin/bash

## filename     composer-specified-update.sh
## description: update a specified composer package on all instances
## author:      jonas@sfxonline.de
## =================================================================

toupdate=$1

for row in $(jq -r '.[] | @base64' data/shops.json); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  dryrun=$(ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update --dry-run" 2>&1)
  echo "$dryrun"

  if echo "$dryrun" | grep -q "$toupdate"
  then
      echo
      echo ">>>>> FOUND '$toupdate' to update"
      ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update $toupdate"
  fi
done
