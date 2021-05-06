#!/bin/bash
cd "$(dirname "$0")"
cd ..

rm target -rf
mkdir target
cp test/test_cases/stew target -r

# build README.adoc
build/build_readme.sh

# build image
build/build_image.sh

# make fodt
docker run -it -v $(pwd):/documents/ -w /documents/target/stew asciidoctor-od a-od-pre -r asciidoctor-mathematical -r asciidoctor-diagram test.adoc -o pre.xml
docker run -it -v $(pwd):/documents/ -w /documents/target/stew asciidoctor-od a-od-out -c /usr/local/a-od/a-od-my/my-cp-example.rb -i pre.xml -o test.fodt

# convert to pdf 
cp build/libre-office/.config target -r
docker run --rm -v $(pwd)/target:/home/alpine woahbase/alpine-libreoffice:x86_64 soffice --headless "macro:///Standard.Module1.toPdf(/home/alpine/stew/test.fodt)"

#test a-od producer
docker run -it -v $(pwd):/documents/ asciidoctor-od ruby test/test.rb  | tee target/unit_test.log

#test final fodt
docker run -it -v $(pwd):/documents/ asciidoctor-od ruby test/test_fodt.rb  | tee target/result_test.log

