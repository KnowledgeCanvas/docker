#

FROM ubuntu:focal as tika_base
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    locales \
    openjdk-16-jre-headless \
    tesseract-ocr \
    imagemagick \
    python3 \
    python3-pip \
    gnupg2 \
    wget
RUN sed -i 's/# \(en_US\.UTF-8 .*\)/\1/' /etc/locale.gen && locale-gen
RUN DEBIAN_FRONTEND=noninteractive pip3 install numpy==1.19.3 scikit-image


FROM tika_base as knowledge_tika
ARG TIKA_VERSION=2.7.0
ARG TIKA_JAR_NAME=tika-server-standard
COPY tika-config.xml tika-config.xml
COPY lib /

USER $UID_GID
EXPOSE 9998
# Note: tika-config.xml will work with the following command, but I have yet to figure out the proper config for Knowledge
#ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /${TIKA_JAR_NAME}-${TIKA_VERSION}.jar -c tika-config.xml -h 0.0.0.0 $0 $@"]
ENTRYPOINT [ "/bin/sh", "-c", "exec java -jar /tika-server-standard-2.7.0.jar -h 0.0.0.0 $0 $@"]
