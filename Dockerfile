FROM cassandra:3.11.5

LABEL maintainer="mail@gdietz.de"

ENV CASSANDRA_READ_REQUEST_TIMEOUT_IN_MS=120000 \
    CASSANDRA_RANGE_REQUEST_TIMEOUT_IN_MS=180000 \
    CASSANDRA_WRITE_REQUEST_TIMEOUT_IN_MS=5000 \
    CASSANDRA_COUNTER_WRITE_REQUEST_TIMEOUT_IN_MS=10000 \
    CASSANDRA_REQUEST_TIMEOUT_IN_MS=180000

COPY ./docker-relaxed-entrypoint.sh /usr/local/bin/docker-relaxed-entrypoint.sh
RUN ln -s /usr/local/bin/docker-relaxed-entrypoint.sh

RUN apt-get update && \
    apt-get install -y \
      less \
      iputils-ping \
      net-tools \
      telnet && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["docker-relaxed-entrypoint.sh"]
