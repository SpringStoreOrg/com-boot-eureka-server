FROM openjdk:11
VOLUME /tmp
COPY ./target/*.jar eureka-server.jar 
ENTRYPOINT ["java","-jar","eureka-server.jar"]
EXPOSE 8761