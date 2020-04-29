FROM anapsix/alpine-java:8_server-jre_unlimited

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

RUN mkdir -p /spring-boot-eureka

WORKDIR /spring-boot-eureka

EXPOSE 8761

ARG JAR_FILE

COPY target/$JAR_FILE ./spring-boot-eureka.jar

CMD java -Djava.security.egd=file:/dev/./urandom -jar spring-boot-eureka.jar
