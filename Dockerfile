FROM eclipse-temurin:21-jdk-jammy
LABEL maintainer="mario.siegenthaler@linkyard.ch"

# Add Tini
ENV TINI_VERSION=v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Prepare for sdk installation
RUN apt-get -y update \
    && apt-get -y install apt-transport-https gnupg2

ENV SDK_VERSION=9.1.1

# # Install atlassian sdk
RUN curl https://maven.artifacts.atlassian.com/com/atlassian/amps/atlassian-plugin-sdk/${SDK_VERSION}/atlassian-plugin-sdk-${SDK_VERSION}.tar.gz -o /tmp/atlassian-plugin-sdk.tar.gz && \
    tar -xvzf /tmp/atlassian-plugin-sdk.tar.gz -C /opt && \
    mv /opt/atlassian-plugin-sdk-${SDK_VERSION} /opt/atlassian-plugin-sdk && \
    rm /tmp/atlassian-plugin-sdk.tar.gz

ENV PATH="/opt/atlassian-plugin-sdk/bin:${PATH}"

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
