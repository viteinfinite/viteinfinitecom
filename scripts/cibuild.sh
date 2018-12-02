#!/bin/bash

# skip if build is triggered by pull request
if [ $TRAVIS_PULL_REQUEST == "true" ]; then
  echo "This is a PR, exiting."
  exit 0
fi

# enable error reporting to the console
set -e

# cleanup "_site"
rm -rf _site
mkdir _site

# clone remote repo to "_site"
git clone https://${GITHUB_TOKEN}@github.com/viteinfinite/viteinfinitecom.git --branch master _site

# build with Jekyll into "_site"
bundle exec jekyll build

# push
cd _site
git checkout --orphan gh-pages
git config user.email "viteinfinite@gmail.com"
git config user.name "Simone Civetta"
git add --all
git commit -a -m "Travis #$TRAVIS_BUILD_NUMBER"
git push --force origin gh-pages
