# syntax=docker/dockerfile:1

FROM ubuntu:focal as base
RUN apt-get update

FROM base as dependencies
ARG JRE='openjdk-16-jre-headless'
ARG TESSERACT='tesseract-ocr'
ARG IMAGEMAGICK='imagemagick'
ARG PYTHON='python3'
ARG PIP='python3-pip'
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install $JRE $TESSERACT $IMAGEMAGICK $PYTHON $PIP
RUN DEBIAN_FRONTEND=noninteractive pip3 install numpy==1.19.3 scikit-image

FROM dependencies as fetch_tika
ARG TIKA_VERSION=2.4.0
ARG TIKA_JAR_NAME=tika-server
ARG CHECK_SIG=true
ENV TIKA_SERVER_URL="https://dlcdn.apache.org/tika/2.4.0/tika-server-standard-2.4.0.jar" \
    TIKA_SERVER_ASC_URL="https://downloads.apache.org/tika/2.4.0/tika-server-standard-2.4.0.jar.asc" \
    TIKA_VERSION=$TIKA_VERSION
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install gnupg2 wget \
    && wget -t 10 --max-redirect 1 --retry-connrefused --no-check-certificate -qO- https://downloads.apache.org/tika/KEYS | gpg --import \
    && wget -t 10 --max-redirect 1 --retry-connrefused --no-check-certificate $TIKA_SERVER_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar || exit 1 \
    && wget -t 10 --max-redirect 1 --retry-connrefused --no-check-certificate $TIKA_SERVER_ASC_URL -O /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc || exit 1
RUN if [ "$CHECK_SIG" = "true" ] ; then gpg --verify /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar.asc /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar; fi

FROM dependencies as runtime
RUN apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ARG TIKA_VERSION=2.4.0
ENV TIKA_VERSION=$TIKA_VERSION
ARG TIKA_JAR_NAME=tika-server
ENV TIKA_JAR_NAME=$TIKA_JAR_NAME
COPY --from=fetch_tika /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar
COPY tika-config.xml tika-config.xml

USER $UID_GID
EXPOSE 9998
# Note: tika-config.xml will work with the following command, but I have yet to figure out the proper config for KC purposes.
#ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar -c tika-config.xml -h 0.0.0.0 $0 $@"]
ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar -h 0.0.0.0 $0 $@"]
LABEL maintainer="Apache Tika Developers dev@tika.apache.org"
