#!/bin/bash

## filename     composer-known-dep-update.sh
## description: update a list of known composer-dependencies
## author:      jonas@sfxonline.de
## =========================================================

toupdate=(aws/aws-sdk-php)
toupdate+=(doctrine/instantiator)
toupdate+=(doctrine/persistence)
toupdate+=(egulias/email-validator)
toupdate+=(ezimuel/ringphp)
toupdate+=(firebase/php-jwt)
toupdate+=(google/auth)
toupdate+=(google/cloud-core)
toupdate+=(laminas/laminas-code)
toupdate+=(phpseclib/phpseclib)
toupdate+=(phpunit/phpunit)
toupdate+=(ramsey/collection)
toupdate+=(scssphp/scssphp)
toupdate+=(sensio/framework-extra-bundle)


for row in $(cat data/shops.json | jq -r '.[] | @base64'); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'    
  dryrun=$(ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update --dry-run" 2>&1)
  echo "$dryrun"

  for i in "${toupdate[@]}"
  do
    if echo "$dryrun" | grep -q "$i"
    then
        echo 
        echo ">>>>> FOUND $i to update"
        ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update $i"
    fi
  done
done



