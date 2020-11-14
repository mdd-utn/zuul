FROM openjdk:12-alpine
ENV TZ=America/Argentina/Mendoza
ENV TERM=xterm

RUN mkdir -p /app
COPY ./target/tool-srv-zuul-0.0.1-SNAPSHOT.jar /app/gateway.jar
WORKDIR /app

EXPOSE 9099/tcp

ENV VIRTUAL_HOST=stg-proxy

ENV spring.application.name=proxy
ENV spring.cloud.config.uri=http://config-server:8888/config-server
ENV management.endpoints.web.exposure.include=*
ENV server.forward-headers-strategy=framework

CMD ["java","-jar","/app/gateway.jar","--server.port=9099"]