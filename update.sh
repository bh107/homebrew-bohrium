#!/usr/bin/env bash -e

filestring=`curl -s https://github.com/bh107/bohrium/releases | grep "archive.*gz" | head -n 1 | cut -d '"' -f2`
url="https://github.com$filestring"
wget -q "$url" -O release.tar.gz
sha=`shasum -a 256 release.tar.gz | cut -d ' ' -f1`
rm release.tar.gz

url=${url//\//\\\/}
perl -i -pe "s/url .*?$/url \"$url\"/g" Formula/bohrium.rb
perl -i -pe "s/sha256 .*?$/sha256 \"$sha\"/g" Formula/bohrium.rb

if [ "$1" == "commit" ]; then
  git commit -am ":gem: Update"
  git push
fi

