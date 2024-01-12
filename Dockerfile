# Use an official OpenJDK runtime as a base image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the red-app JAR file into the container at /app
COPY red-app.jar /app/red-app.jar

# Specify the command to run on container startup
CMD ["java", "-jar", "red-app.jar"]

