#!/bin/bash
cd "$(dirname "$0")"
cd ..

mkdir target
mkdir target/out
cp test/test_cases/typography target -r

echo build image
build/build_image.sh

echo make pdf
docker run --rm -v $(pwd):/documents/ -w /documents/target/typography curs/asciidoctor-od a-od ttest.adoc pdf

echo make odt
docker run --rm -v $(pwd):/documents/ -w /documents/target/typography curs/asciidoctor-od a-od ttest.adoc odt

cp target/typography/ttest.* target/out
