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
#docker run --rm -v $(pwd):/documents/ -w /documents/ asciidoctor-od build/build_readme.sh
docker run --rm -v $(pwd):/documents/ -w /documents/ asciidoctor-od asciidoctor docs/a-od-basic-doc.adoc -o target/out/index.html

echo make fodt
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew asciidoctor-od a-od-pre -r asciidoctor-mathematical -r asciidoctor-diagram test.adoc -o pre.xml
docker run --rm -v $(pwd):/documents/ -w /documents/target/stew asciidoctor-od a-od-out -c /usr/local/a-od/a-od-my/my-cp-example.rb -i pre.xml -o test.fodt

#tag::pdf_convert[]
echo convert to pdf, odt, docx
docker run -d --name libreoffice -p 8100:8100 hdejager/libreoffice-api
sleep 3
docker cp target/stew/test.fodt libreoffice:/tmp/test.fodt
docker exec -i libreoffice unoconv --connection \
    'socket,host=127.0.0.1,port=8100,tcpNoDelay=1;urp;StarOffice.ComponentContext' \
    -f pdf /tmp/test.fodt
docker exec -i libreoffice unoconv --connection \
    'socket,host=127.0.0.1,port=8100,tcpNoDelay=1;urp;StarOffice.ComponentContext' \
    -f odt /tmp/test.fodt
docker exec -i libreoffice unoconv --connection \
    'socket,host=127.0.0.1,port=8100,tcpNoDelay=1;urp;StarOffice.ComponentContext' \
    -f docx /tmp/test.fodt
docker cp libreoffice:/tmp/test.odt target/stew
docker cp libreoffice:/tmp/test.pdf target/stew
docker cp libreoffice:/tmp/test.docx target/stew
docker kill libreoffice
docker rm libreoffice
cp target/stew/test.pdf target/out
cp target/stew/test.odt target/out
cp target/stew/test.docx target/out
cp target/stew/test.fodt target/out
#end::pdf_convert[]

echo test a-od producer
docker run --rm -v $(pwd):/documents/ asciidoctor-od ruby test/test.rb  | tee target/unit_test.log

echo test final fodt
docker run --rm -v $(pwd):/documents/ asciidoctor-od ruby test/test_fodt.rb  | tee target/result_test.log

