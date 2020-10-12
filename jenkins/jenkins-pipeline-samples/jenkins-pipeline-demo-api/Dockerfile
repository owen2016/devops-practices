ARG OPENJRE_TAG=8u151-jre-alpine3.7

FROM openjdk:$OPENJRE_TAG

LABEL com.maintainer=" Mayank Patel <mayank.patel@yourdomain.com> " \
      com.description=" Platform Billing REST API " \
      com.gitURL="https://github.com/maxyermayank/jenkins-pipeline-demo-api"

USER root

WORKDIR /root

ARG API_NAME=jenkins-pipeline-demo-api
ARG JOLOKIA_VERSION=1.5.0
ARG API_PORT=9505
ARG JMX_PORT=9605
ARG DEBUG_PORT=9705
ARG APP_ENVIRONMENT

RUN apk update && \
    apk add --update bash wget curl procps unzip git openssh-client openrc jq && \
    rm -rf /var/cache/apk/* *.tar.gz

COPY --chown=root ./target/universal/*.zip /root/

RUN mkdir -p /usr/lib/check_mk_agent/local/jvm \
    && wget http://search.maven.org/remotecontent?filepath=org/jolokia/jolokia-jvm/$JOLOKIA_VERSION/jolokia-jvm-$JOLOKIA_VERSION-agent.jar -P /usr/lib/check_mk_agent/local/jvm/

RUN unzip *.zip \
    && rm -f *.zip \
    && ln -s $API_NAME-* $API_NAME \
    && cd $API_NAME && chmod +x $API_NAME \
    && ln -s /root/$API_NAME/$API_NAME /etc/init.d/api \
    && ln -s /var/logs/$API_NAME.log /root/api.log

EXPOSE $API_PORT $DEBUG_PORT $JMX_PORT

ENTRYPOINT ["service api start"]
