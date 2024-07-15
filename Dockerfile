
FROM debian:latest

RUN apt-get update && \
    apt-get install -y sudo stress powerstat && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


ADD power.sh /usr/local/bin/power.sh
ADD entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/power.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

