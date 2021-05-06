FROM asciidoctor/docker-asciidoctor:latest

RUN gem install fastimage nokogiri minitest pry

COPY . /usr/local/a-od/
ENV PATH="$PATH:/usr/local/a-od/"
