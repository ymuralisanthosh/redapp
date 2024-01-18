# Use an official OpenJDK runtime as a base image
FROM openjdk:11-jre-slim

# Set the working directory
WORKDIR /app

# Copy the red-app JAR file into the container at /app
EXPOSE 8080

# Specify the command to run on container startup
CMD ["java", "-jar", "red-app.jar"]

