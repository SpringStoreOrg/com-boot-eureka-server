FROM eclipse-temurin:17-jdk-alpine
COPY ./target/*.jar eureka-server.jar
ENTRYPOINT ["java","-jar","eureka-server.jar"]