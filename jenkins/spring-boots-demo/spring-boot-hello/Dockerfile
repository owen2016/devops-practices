FROM anapsix/alpine-java:8_server-jre_unlimited

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir -p /spring-boot-hello

WORKDIR /spring-boot-hello

EXPOSE 8762

ARG JAR_FILE

COPY target/$JAR_FILE ./spring-boot-hello.jar

CMD java -Djava.security.egd=file:/dev/./urandom -jar spring-boot-hello.jar
