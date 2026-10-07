FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build
COPY pom.xml .
RUN mvn -B -q dependency:go-offline
COPY src ./src
RUN mvn -B -q compile

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /build/target/classes ./classes
ENV PORT=8086
EXPOSE 8086
CMD ["java", "-cp", "classes", "com.library.billing.BillingApplication"]