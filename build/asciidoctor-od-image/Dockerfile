FROM asciidoctor/docker-asciidoctor:latest

RUN gem install fastimage nokogiri minitest pry

COPY . /usr/local/a-od/
ENV PATH="/usr/local/a-od:${PATH}"
RUN echo "PATH="${PATH}"" >> /etc/environment
