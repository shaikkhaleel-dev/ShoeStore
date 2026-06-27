# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src

# This is the single, clean build line that completely skips tests
RUN mvn clean package -Dmaven.test.skip=true -Dorg.slf4j.simpleLogger.defaultLogLevel=warn -XX:+UseSerialGC

# Stage 2: Run the application
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
# Copy the built jar from the first stage and rename it to app.jar
COPY --from=build /app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "app.jar"]