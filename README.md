# Development

```bash
mvn package
docker build . -t fractalwoodstories/eureka-server:latest
docker push fractalwoodstories/eureka-server:latest
helm upgrade --install eureka-server ./helm/eureka-server
```