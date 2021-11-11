#!/bin/bash
cd "$(dirname "$0")"
cd ..

rm target -rf
mkdir target
mkdir target/out
cp test/test_cases/stew target -r

cd target/stew
asciidoctor -b fodt -T ../../lib/slim -r asciidoctor-mathematical -r asciidoctor-diagram test.adoc -o pre.xml
ruby ../../lib/a-od-producer/asciidoctor-od.rb  -i pre.xml -o test.fodt

