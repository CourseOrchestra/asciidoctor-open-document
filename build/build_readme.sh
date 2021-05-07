#!/bin/bash
cd "$(dirname "$0")"

ruby asciidoc-coalescer.rb ../docs/a-od-basic-doc.adoc -o ../README.adoc
