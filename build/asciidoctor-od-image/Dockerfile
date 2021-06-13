FROM asciidoctor/docker-asciidoctor:latest

RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    ruby-dev \
 && gem install --no-document \
    fastimage \
    nokogiri \
    minitest \
    pry

COPY . /usr/local/a-od/
ENV PATH="/usr/local/a-od:${PATH}"
RUN chmod +x /usr/local/a-od/a-od-pre && chmod +x /usr/local/a-od/a-od-out
