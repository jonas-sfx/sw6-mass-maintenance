#!/bin/bash

## filename     find-hugefiles.sh
## description: find huge files in your setup
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
  echo 'Host:    ' $(_jq '.host')
  echo 'Webroot: ' $(_jq '.webroot')
  ssh "$(_jq '.host')" "find $(_jq '.webroot') -type f -size +50M -exec ls -lah {} \;"
done