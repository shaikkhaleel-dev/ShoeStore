# Stage 1: Build the application using Java 21
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# 1. Copy ONLY the pom.xml first to download dependencies
COPY pom.xml .
# This downloads all dependencies into a cached layer. 
# It will skip downloading next time unless pom.xml changes.
RUN mvn dependency:go-offline -B

# 2. Copy the source code now and build
COPY src ./src
RUN mvn clean package -Dmaven.test.skip=true -B

# Stage 2: Run the application using Java 21 JRE
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=build /app/target/*.war app.war

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.war"]