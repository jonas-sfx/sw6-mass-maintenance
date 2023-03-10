#!/bin/bash

## filename     composer-update-certain.sh
## description: update a certain composer package on all instances
##              where its already in use
## author:      jonas@sfxonline.de
## =========================================================

toupdate=$1

for row in $(jq -r '.[] | @base64' data/shops.json ); do
    _jq() {
     echo "${row}" | base64 --decode | jq -r "${1}"
    }
  echo
  echo '-----------------'
  _jq '.name'
  echo '-----------------'
  echo '==> just doing a dry-run first to check availability:'
  echo '-----------------------------------------------------'
  echo
  dryrun=$(ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update --dry-run" 2>&1)
  echo "$dryrun"

  if [[ $toupdate == *"*"* ]]; then
    matches=$(echo "$dryrun" | grep -c "$toupdate")
    echo ">>>>> FOUND WILDCARD ""$toupdate"" to update (""$matches"" MATCHES)"

    if [ "$matches" -gt 1 ]; then
      echo '==> doing the real update:'
      echo
      ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update $toupdate"
      # TODO: SW-Console Update on each wildcard-match
    fi

  elif echo "$dryrun" | grep -q "$toupdate"; then
      echo
      echo ">>>>> FOUND ""$toupdate"" to update (EXACT MATCH)"
      echo '==> doing the real update:'
      echo
      ssh "$(_jq '.host')" "cd  $(_jq '.webroot') && $(_jq '.composer') update $toupdate"

      # SW-Console: Determine SW-Name of Plugin and du SW-Console Update with that one
      ssh "$(_jq '.host')" "$(_jq '.console') plugin:refresh"
      swname=$(ssh "$(_jq '.host')" "$(_jq '.console') plugin:list --json | jq -r '.[] |  select(.composerName == "$toupdate" and .upgradeVersion != .version) .name'")
      if [ ! -z "$swname" ]; then
        ssh "$(_jq '.host')" "$(_jq '.console') plugin:update $swname"
      fi

  fi
done
