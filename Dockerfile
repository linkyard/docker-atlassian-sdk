FROM adoptopenjdk/openjdk8
LABEL maintainer="mario.siegenthaler@linkyard.ch"

# Add Tini
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Prepare for sdk installation
RUN apt-get -y update \
    && apt-get -y install apt-transport-https

ENV SDK_VERSION=8.0.16

# Install atlassian sdk
RUN echo "deb https://packages.atlassian.com/debian/atlassian-sdk-deb/ stable contrib" >>/etc/apt/sources.list \
    && apt-get -y install gnupg2 \
    && curl https://packages.atlassian.com/api/gpg/key/public -o /tmp/public \
    && apt-key add /tmp/public \
    && apt-get -y update \
    && apt-get -y install atlassian-plugin-sdk=${SDK_VERSION}

RUN mkdir -p /app
WORKDIR /app

EXPOSE 2990
EXPOSE 5005

CMD ["atlas-version"]
