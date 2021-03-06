#!/bin/bash

## inspired by https://github.com/elm-community/webgl/blob/master/release.sh

set -euxo pipefail

rm -rf release || exit 0;

elm-package bump

version=$(grep -m1 version elm-package.json | awk -F: '{ print $2 }' | sed 's/[", ]//g')

git commit -a -m "Bump to $version"
git push

cleanup="docs images vlExamples vlTest-gallery vlTests release.sh"
last_commit=$(git rev-parse HEAD)

git clone --reference . git@github.com:gicentre/elm-vega.git release
(
  cd release
  git checkout $last_commit
  git rm -rf --ignore-unmatch $cleanup
  git commit -m "Cleanup and release $version"
  git tag -a $version -m "Release $version"
  git push origin $version
  elm-package publish
)
