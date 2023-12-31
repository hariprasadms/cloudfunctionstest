# Use a specific version of the Dart SDK and Alpine Linux as the base image
FROM google/dart:2.15.1 AS build

# Install unzip tool
RUN apt-get update && apt-get install -y unzip

# Set the working directory in the container
WORKDIR /app

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /flutter && /flutter/bin/flutter --version

# Add Flutter to the system path
ENV PATH="/flutter/bin:${PATH}"

# Copy the pubspec.yaml and pubspec.lock files to the container
COPY pubspec.yaml pubspec.lock ./

# Get the dependencies (this step is separated to leverage Docker cache)

RUN dart pub global activate build_runner

ENV PATH="/root/.pub-cache/bin:${PATH}"

RUN flutter pub get

# Copy the entire project to the container
COPY . .

RUN rm -rf .dart_tool/

RUN dart pub get
RUN flutter pub get

# Build the Flutter web application
RUN flutter build web

# Use a lightweight base image for the final image
FROM gcr.io/distroless/static-debian11

# Set the working directory
WORKDIR /usr/src/app

# Copy the build output from the previous stage to the final image
COPY --from=build /app/build /usr/src/app/build

# Specify the command to run the web server
CMD ["build_runner", "serve", "-o", "web:build"]
