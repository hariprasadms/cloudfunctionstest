# Use a specific version of the Dart SDK and Alpine Linux as the base image
FROM google/dart:2.15 AS build

# Install unzip tool
RUN apt-get update && apt-get install -y unzip

# Set the working directory in the container
WORKDIR /app

# Specify the Flutter version you want to install
ARG FLUTTER_VERSION=3.10.4

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter && /flutter/bin/flutter --version

# Add Flutter to the system path
ENV PATH="/flutter/bin:${PATH}"

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock ./

# Get the dependencies (this step is separated to leverage Docker cache)
RUN flutter pub get

# Copy the entire project to the container
COPY . .

# Build the Flutter web app
RUN flutter build web

# Use a lightweight Alpine Linux as the final base image
FROM alpine:latest

# Set the working directory in the container
WORKDIR /app

# Copy the built Flutter web app from the build stage
COPY --from=build /app/build/web /app

# Expose the port the app runs on (default is 80 for HTTP server)
EXPOSE 80

# Start the Flutter web app when the container starts
CMD ["python3", "-m", "http.server", "80"]
