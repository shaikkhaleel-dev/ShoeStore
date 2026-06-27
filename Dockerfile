# Stage 1: Build the application using Java 21
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline -B

COPY src ./src
RUN mvn clean package -Dmaven.test.skip=true -B

# Stage 2: Run the application using Java 21 JRE
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.war app.war

EXPOSE 8080
# FIXED: Pointing to app.war instead of app.jar
ENTRYPOINT ["java", "-jar", "app.war"]