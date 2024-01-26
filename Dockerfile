FROM eclipse-temurin:11-jdk-jammy
LABEL maintainer="mario.siegenthaler@linkyard.ch"

# Add Tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Prepare for sdk installation
RUN apt-get -y update \
    && apt-get -y install apt-transport-https gnupg2

ENV SDK_VERSION=8.2.8

# # Install atlassian sdk
RUN echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list
RUN echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list \
    && curl https://packages.atlassian.com/api/gpg/key/public -o /tmp/public \
    && apt-key add /tmp/public
RUN apt-get -y update
RUN apt-get -y install atlassian-plugin-sdk=${SDK_VERSION}

# Do a mock-build to download most the deps... speeds up the real build afterwards
COPY mock-plugin /tmp/mock-plugin
RUN cd /tmp/mock-plugin \
    && atlas-mvn package \
    && rm -rf /tmp/mock-plugin

RUN mkdir -p /app
WORKDIR /app

EXPOSE 2990
EXPOSE 5005

CMD ["atlas-version"]
