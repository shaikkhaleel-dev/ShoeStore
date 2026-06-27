# Stage 1: Build the WAR application using Java 21
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app

# Cache dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build the WAR file
COPY src ./src
RUN mvn clean package -Dmaven.test.skip=true -B

# Stage 2: Deploy to Apache Tomcat 10 with Java 21
FROM tomcat:10.1-jdk21-temurin-jammy
WORKDIR /usr/local/tomcat

# Remove the default ROOT application provided by Tomcat
RUN rm -rf webapps/ROOT webapps/ROOT.war

# Copy your built war file into Tomcat's webapps directory as ROOT.war
COPY --from=build /app/target/*.war webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]