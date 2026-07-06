#!/usr/bin/env bash

# remove files not covered by index
for f in tei/*.xml; do
  slug=$(basename "$f" .xml)
  if ! grep -q "slug=\"$slug\"" index.xml; then
    rm -v "$f"
  fi
done

saxon -s:index.xml -xsl:perseus2dracor.xsl \
  perseus-sha=$(git -C perseusdl rev-parse HEAD) \
  out-dir='tei'