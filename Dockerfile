# Lightweight base image
FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/games:${PATH}"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        fortune-mod \
        fortunes-min \
        cowsay \
        netcat \
        bash && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
WORKDIR /app
COPY wisecow.sh .
RUN chmod +x wisecow.sh

EXPOSE 4499

CMD ["./wisecow.sh"]
