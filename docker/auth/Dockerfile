FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q compile

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /build/target/classes ./classes
ENV PORT=8081
EXPOSE 8081
CMD ["java", "-cp", "classes", "com.library.auth.AuthApplication"]