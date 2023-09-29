# Use a specific version of the Dart SDK and Alpine Linux as the base image
FROM google/dart:2.15 AS build

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
RUN flutter pub get

# Copy the entire project to the container
COPY . .

RUN dart pub get
RUN flutter pub get

# Build the Flutter web application
RUN pub run build_runner build --output=web:build

# Use a lightweight base image for the final image
FROM gcr.io/distroless/web

# Set the working directory
WORKDIR /usr/src/app

# Copy the build output from the previous stage to the final image
COPY --from=build /app/build /usr/src/app/build

# Specify the command to run the web server
CMD ["build_runner", "serve", "-o", "web:build"]
