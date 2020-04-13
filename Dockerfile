#
# Elasticsearch Dockerfile
#
# https://github.com/dockerfile/elasticsearch
#

FROM ubuntu:18.04

#install java
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends software-properties-common && \
    (echo openjdk-8-jdk shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    apt-get install -y wget && \
    rm -rf /var/cache/oracle-jdk8-installer && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

ENV ES_PKG_NAME elasticsearch-1.5.0

# Install Elasticsearch.
# Install Elasticsearch.
RUN \
  cd / && \
  wget https://download.elasticsearch.org/elasticsearch/elasticsearch/$ES_PKG_NAME.tar.gz && \
  tar xvzf $ES_PKG_NAME.tar.gz && \
  rm -f $ES_PKG_NAME.tar.gz && \
  mv /$ES_PKG_NAME /elasticsearch


#install jprofiler
RUN wget https://download-gcdn.ej-technologies.com/jprofiler/jprofiler_linux_11_1_2.tar.gz -P /tmp/ &&\
 tar -xzf /tmp/jprofiler_linux_11_1_2.tar.gz -C /usr/local &&\
 rm /tmp/jprofiler_linux_11_1_2.tar.gz

ENV JPAGENT_PATH="-agentpath:/usr/local/jprofiler11.1.2/bin/linux-x64/libjprofilerti.so=nowait"





#ajout fichiers configuration
COPY logging.yml /usr/share/elasticsearch/config/
COPY elasticsearch.yml /usr/share/elasticsearch/config/

#lancer elasticsearch au démarrage

CMD ["/elasticsearch/bin/elasticsearch"]


# Expose ports.
#   - 9200: HTTP
#   - 9300: transport
#   - 8849: JProfiler
EXPOSE 9200
EXPOSE 9300
EXPOSE 8849
