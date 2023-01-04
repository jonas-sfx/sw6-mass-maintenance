#!/bin/bash

## filename     console-plugin-list.sh
## description: run "console plugin:list" on the sw console of each shop
##              listing your currently installed shopware plugins
## author:      jonas@sfxonline.de
## =======================================================================

for row in $(cat data/shops.json | jq -r '.[] | @base64'); do
    _jq() {
     echo ${row} | base64 --decode | jq -r ${1}
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  ssh $(_jq '.host') "$(_jq '.console') plugin:list"
done