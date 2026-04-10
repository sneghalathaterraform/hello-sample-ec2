# ---- Build Stage ----
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# ---- Run Stage ----
FROM eclipse-temurin:21-jdk
WORKDIR /app
COPY --from=build /app/target/buildproject-0.0.1-SNAPSHOT.war /app/buildproject.war
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/buildproject.war"]
