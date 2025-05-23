### Example:
### mvn package && docker build . -t petclinic:latest

FROM maven:3.6.0-jdk-11-slim

WORKDIR home

COPY target/spring-petclinic*.jar .

###ENTRYPOINT java -jar spring-petclinic*.jar

EXPOSE 8080

CMD java -Xmx512m -Xms512m -jar spring-petclinic*.jar --server.port=8080
