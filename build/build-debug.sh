#!/bin/bash
cd "$(dirname "$0")"
cd ..

rm target -rf
mkdir target
mkdir target/out
cp test/test_cases/stew target -r
cp test/test_cases/asciidoctor-pdf target -r

cd target/stew
#ruby ../../test/test.rb
asciidoctor -b fodt -T ../../lib/slim -r asciidoctor-mathematical -r asciidoctor-diagram test.adoc -o pre.xml
#ruby ../../lib/a-od-producer/asciidoctor-od.rb -c ../../lib/a-od-my/my-cp-example.rb -i pre.xml -o test.fodt
ruby ../../lib/a-od-producer/asciidoctor-od.rb -i pre.xml -o test.fodt
docker run --rm -v $(pwd):/documents/ curs/asciidoctor-od unoconv -f pdf test.fodt
cd ../..

#cd target/asciidoctor-pdf
#asciidoctor -b fodt -T ../../lib/slim -r asciidoctor-mathematical -r asciidoctor-diagram chronicles-example.adoc -o pre.xml
#ruby ../../lib/a-od-producer/asciidoctor-od.rb  -i pre.xml -f chronicles-template.fodt -o chronicles-example.fodt
#docker run --rm -v $(pwd):/documents/ curs/asciidoctor-od unoconv -f pdf chronicles-example.fodt
#cd ../..

