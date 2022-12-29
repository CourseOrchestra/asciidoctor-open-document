#!/bin/bash
cd "$(dirname "$0")"
cd ..

rm target -rf
mkdir target
mkdir target/out
cp test/test_cases/stew target -r

echo build image
build/build_image.sh

echo build README.adoc
docker run --rm -v $(pwd):/documents/ -w /documents/ curs/asciidoctor-od asciidoctor docs/a-od-basic-doc.adoc -o target/out/index.html

echo make fodt
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od a-od-pre -r asciidoctor-mathematical -r asciidoctor-diagram test.adoc -o pre.xml
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od a-od-out -c /usr/local/a-od/a-od-my/my-cp-example.rb -i pre.xml -o test.fodt_

#tag::pdf_convert[]
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od unoconv -f fodt test.fodt_
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od unoconv -f pdf test.fodt_
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od unoconv -f odt test.fodt_
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew curs/asciidoctor-od unoconv -f docx test.fodt_
#end::pdf_convert[]

cp target/stew/test.* target/out

echo test a-od producer
docker run --rm -v $(pwd):/documents/ curs/asciidoctor-od ruby test/test.rb  | tee target/unit_test.log

echo test final fodt
docker run --rm -v $(pwd):/documents/ curs/asciidoctor-od ruby test/test_fodt.rb  | tee target/result_test.log

if grep -q "[1-9][0-9]* failures" target/unit_test.log; then
    echo test.rb failed
    exit 1
fi

if test -f target/out/test.odt; then
    echo odt outputed
else
    echo no output odt
    exit 1
fi

if grep -q "[1-9][0-9]* fodt errors" target/result_test.log; then
    echo output failed
    exit 1
fi
