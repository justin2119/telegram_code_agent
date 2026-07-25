# Stage 1: Build the Dart application
FROM dart:stable AS build

WORKDIR /app

# Copy pubspec and get dependencies
COPY pubspec.yaml ./
RUN dart pub get

# Copy the rest of the source code
COPY . .

# Compile the native executable
RUN dart compile exe lib/presentation/main.dart -o telegram_code_agent

# Stage 2: Minimal runtime image
FROM debian:bookworm-slim

# Install certificates for HTTPS
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /app/telegram_code_agent /app/telegram_code_agent

# Expose health check port (used by Fly.io, Render, etc.)
EXPOSE 7860

# Run the bot
CMD ["/app/telegram_code_agent"]
