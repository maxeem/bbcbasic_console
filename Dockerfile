# Dockerfile
FROM debian:bookworm-slim AS builder

# Install unzip to unpack the archive
RUN apt-get update && apt-get install -y unzip wget && rm -rf /var/lib/apt/lists/*

# Fetch and unpack BBC BASIC
WORKDIR /opt
RUN wget https://www.bbcbasic.co.uk/console/bbcbasic_console_linux.zip \
    && unzip bbcbasic_console_linux.zip \
    && rm bbcbasic_console_linux.zip

# Final stage: minimal runtime
FROM debian:bookworm-slim
WORKDIR /bbcbasic

# Copy just the binary and lib folder
COPY --from=builder /opt/bbcbasic /bbcbasic/bbcbasic
COPY --from=builder /opt/lib /bbcbasic/lib

# Default entrypoint: run bbcbasic
ENTRYPOINT ["/bbcbasic/bbcbasic"]
