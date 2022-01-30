FROM openjdk:11
COPY ./target/*.jar eureka-server.jar 
ENTRYPOINT ["java","-jar","eureka-server.jar"]