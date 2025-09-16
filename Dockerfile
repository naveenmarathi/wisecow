# Lightweight base image
FROM debian:bullseye-slim

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
# Add /usr/games to PATH for fortune & cowsay
ENV PATH="/usr/games:${PATH}"

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fortune-mod \
        fortunes-min \
        cowsay \
        netcat \
        bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy your server script
COPY wisecow.sh .

# Ensure it is executable
RUN chmod +x wisecow.sh

# Expose Wisecow server port
EXPOSE 4499

# Start the server
CMD ["./wisecow.sh"]
