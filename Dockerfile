FROM java:7-jdk

RUN \
    apt-get update \
    && apt-get install -y unzip curl \
    && apt-get -y clean && apt-get -y autoclean \
    && mkdir -p /opt/twofishes

ENV TWOFISHES_VERSION="0.84.9" \
    TWOFISHES_DATAINDEX_VERSION="2015-03-05" \
    TWOFISHES_JAVA_OPTS="-Xmx2g -Xms2g"

VOLUME /opt/twofishes

COPY ./entrypoint.sh /

EXPOSE 8080 8081 8082 8083

ENTRYPOINT ["/entrypoint.sh"]
CMD ["twofishes"]
