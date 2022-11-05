FROM asciidoctor/docker-asciidoctor:latest

RUN apk add --no-cache \
    build-base \
    libxml2-dev \
    ruby-dev \
    openjdk11 \
    && rm -rf /var/cache/apk/* \
    && gem install --no-document \
    fastimage \
    nokogiri \
    minitest \
    pry

RUN set -xe \
    && apk add --no-cache --purge -uU \
        curl icu-libs unzip zlib-dev musl \
        mesa-gl mesa-dri-swrast \
        libreoffice libreoffice-base libreoffice-lang-uk \
        ttf-freefont ttf-opensans ttf-ubuntu-font-family ttf-inconsolata \
	ttf-liberation ttf-dejavu \
        libstdc++ dbus-x11 \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
    && apk add --no-cache -U \
	ttf-font-awesome ttf-mononoki ttf-hack \
    && rm -rf /var/cache/apk/* /tmp/*


ENV UNO_URL https://raw.githubusercontent.com/dagwieers/unoconv/master/unoconv

RUN curl -Ls $UNO_URL -o /usr/local/bin/unoconv \
  && chmod +x /usr/local/bin/unoconv \
  && ln -s /usr/bin/python3 /usr/bin/python

COPY . /usr/local/a-od/
ENV PATH="/usr/local/a-od:${PATH}"
RUN chmod +x /usr/local/a-od/a-od-pre && chmod +x /usr/local/a-od/a-od-out && chmod +x /usr/local/a-od/a-od
