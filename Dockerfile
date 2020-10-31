FROM openjdk:12-alpine
#FROM openjdk:alpine
ENV TZ=America/Argentina/Mendoza
ENV TERM=xterm

RUN mkdir -p /app
COPY ./target/tool-srv-zuul-0.0.1-SNAPSHOT.jar /app/gateway.jar
WORKDIR /app

EXPOSE 9099/tcp

ENV VIRTUAL_HOST=stg-tool-srv-zuul
ENV VIRTUAL_PORT=9099
ENV server.port=9099
ENV server.servlet.context-path=/services

ENV spring.application.name=zuul-server
ENV spring.cloud.config.uri=http://config-server:8888/config-server
ENV management.endpoints.web.exposure.include=*


CMD ["java","-jar","/app/gateway.jar","--server.port=9099"]