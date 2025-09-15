# Lightweight base image
FROM debian:bullseye-slim

# Set environment variables to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fortune-mod \
        cowsay \
        netcat \
        bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your shell script into the image
COPY wisecow.sh .

# Make sure the script is executable
RUN chmod +x wisecow.sh

# Expose the port used by the app
EXPOSE 4499

# Run the script
CMD ["./wisecow.sh"]
